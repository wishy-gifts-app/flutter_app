import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:Wishy/global_manager.dart';
import 'graphql_queries.dart';

Future<dynamic> graphQLQueryHandler(
    String queryName, Map<String, dynamic> variables) async {
  final String? queryString = graphqlQueries[queryName];

  if (queryString == null) {
    throw Exception("Query named $queryName not found");
  }

  final http.Client _client = http.Client();

  final Map<String, dynamic> formattedVariables = {};
  variables.forEach((key, value) {
    if (value is DateTime) {
      formattedVariables[key] = value.toIso8601String();
    } else {
      formattedVariables[key] = value;
    }
  });

  final Map<String, dynamic> requestBody = {
    "query": queryString,
    "variables": formattedVariables,
  };

  try {
    final token = GlobalManager().token;
    final http.Response response = await _client.post(
      Uri.parse(dotenv.get("GRAPHQL_API_URL")),
      headers: {
        "Content-Type": "application/json",
        "auth": token!,
        "user_country": GlobalManager().userLocation?.country ?? "",
        "iso_code": GlobalManager().userLocation?.isoCode ?? "",
        "session": GlobalManager().session ?? "",
      },
      body: jsonEncode(requestBody),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode != 200) throw Exception(requestBody);
    await GlobalManager()
        .setParams(newToken: response.headers["auth"] ?? token);

    return responseBody["data"][queryName];
  } catch (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
    print("Error sending GraphQL query: $error");
  } finally {
    _client.close();
  }
}

class GraphQLPaginationService {
  final String queryName;
  Map<String, dynamic> variables;
  final bool infiniteScroll;
  final bool cashNextPage;
  Future<List<dynamic>>? _nextPagePromise = null;
  final String? firstCursor;
  String? cursor;
  bool _hasNextPage = true;

  GraphQLPaginationService(
      {required this.queryName,
      required this.variables,
      this.firstCursor = null,
      this.cashNextPage = true,
      this.infiniteScroll = false});

  Future<List<dynamic>> runGraphQLQueryWithPagination(int? startId) async {
    if (this.cursor == null) this.cursor = this.firstCursor;

    final result = await graphQLQueryHandler(this.queryName,
        {...this.variables, "start_id": startId, "cursor": this.cursor});
    final pageInfo = result['pageInfo'];

    if (pageInfo['hasNextPage']) {
      cursor = pageInfo['endCursor'];
    } else {
      cursor = null;
    }

    return result["results"];
  }

  Future<Map<String, dynamic>> run({int? startId = null}) async {
    if (!this._hasNextPage) {
      return {
        "data": null,
        "hasNextPage": this._hasNextPage,
      };
    }

    List<dynamic> result = this._nextPagePromise != null
        ? await this._nextPagePromise!
        : await runGraphQLQueryWithPagination(startId);

    if (infiniteScroll && this.cursor == null && result.length == 0) {
      result = await runGraphQLQueryWithPagination(startId);
    }

    if (!infiniteScroll && this.cursor == null) {
      this._hasNextPage = false;
    } else if (this.cashNextPage) {
      this._nextPagePromise = runGraphQLQueryWithPagination(null);
    }

    return {
      "data": result,
      "hasNextPage": this._hasNextPage,
    };
  }

  void reset() {
    cursor = null;
    _hasNextPage = true;
  }
}

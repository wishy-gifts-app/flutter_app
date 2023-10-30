import 'dart:convert';
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
      headers: {"Content-Type": "application/json", "auth": token!},
      body: jsonEncode(requestBody),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode != 200) throw requestBody;
    await GlobalManager()
        .setParams(newToken: response.headers["auth"] ?? token);

    return responseBody["data"][queryName];
  } catch (error) {
    print("Error sending GraphQL query: $error");
    throw error;
  } finally {
    _client.close();
  }
}

class GraphQLPaginationService {
  final String queryName;
  final Map<String, dynamic> variables;
  final bool infiniteScroll;
  Future<List<dynamic>>? _nextPagePromise = null;
  String? cursor;
  bool _hasNextPage = true;

  GraphQLPaginationService(
      {required this.queryName,
      required this.variables,
      this.infiniteScroll = false});

  Future<List<dynamic>> runGraphQLQueryWithPagination() async {
    final result = await graphQLQueryHandler(
        this.queryName, {...this.variables, "cursor": this.cursor});
    final pageInfo = result['pageInfo'];

    if (pageInfo['hasNextPage']) {
      cursor = pageInfo['endCursor'];
    } else {
      cursor = null;
    }

    return result["results"];
  }

  Future<Map<String, dynamic>> run() async {
    if (!this._hasNextPage) {
      return {
        "data": null,
        "hasNextPage": this._hasNextPage,
      };
    }

    final result = await runGraphQLQueryWithPagination();

    if (!infiniteScroll && this.cursor == null) {
      this._hasNextPage = false;
    }

    return {
      "data": result,
      "hasNextPage": this._hasNextPage,
    };
  }
}

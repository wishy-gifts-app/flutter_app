import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/global_manager.dart';
import 'graphql_queries.dart';

class GraphQLService {
  Future<Map<String, dynamic>> runGraphQLQuery(String queryName,
      String queryString, Map<String, dynamic> variables) async {
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
      print(response.statusCode);
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

  Future<Map<String, dynamic>> runGraphQLQueryWithPagination(
    String queryName,
    String queryString,
    Map<String, dynamic> variables,
  ) async {
    String? cursor;
    bool hasNextPage = true;
    final fetchData = () async {
      final result = await runGraphQLQuery(
          queryName, queryString, {...variables, "cursor": cursor});
      final pageInfo = result['pageInfo'];

      if (pageInfo['hasNextPage']) {
        cursor = pageInfo['endCursor'];
      } else {
        hasNextPage = false;
      }

      return result["results"];
    };

    var nextPageData;
    if (hasNextPage) {
      nextPageData = fetchData();
    }

    final nextPage = () async {
      if (!hasNextPage) {
        return null;
      }

      return await nextPageData;
    };

    return {
      'hasNextPage': hasNextPage,
      'nextPage': nextPage,
    };
  }

  Future<Map<String, dynamic>> queryHandler(
      String queryName, Map<String, dynamic> variables,
      {bool withPagination = false,
      bool throwOnError = true,
      String? errorMessage = null}) async {
    final String? queryString = graphqlQueries[queryName];

    if (queryString == null) {
      throw Exception("Query named $queryName not found");
    }

    if (withPagination) {
      return await runGraphQLQueryWithPagination(
          queryName, queryString, variables);
    } else {
      return await runGraphQLQuery(queryName, queryString, variables);
    }
  }
}

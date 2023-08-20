const Map<String, String> graphqlQueries = {
  'updateUserById': """
    mutation updateUserById(
      \$id: Int!,    
      \$phone_number: String,
      \$name: String,
      \$gender: String,
      \$address: String,
      \$birthday: Date
    ) {
      updateUserById(
        id: \$id,
        phone_number: \$phone_number,
        name: \$name,
        gender: \$gender,
        address: \$address,
        birthday: \$birthday
      ) {
        id
      }
    }
  """,
  'getProductsFeed': """
    query getProductsFeed(
      \$limit: Int!,
      \$cursor: String
    ) {
      getProductsFeed(
        limit: \$limit,
        cursor: \$cursor
      ) {
        results {
          id
          title
          total_inventory
          total_variants
          description
          shop_id
          like_created_at
          tags
          variants {
            id
            title
            weight
            price
            inventory_quantity
          }
          images {
            id
            variant_id
            url
            alt
          }
          vendor_name
        }
        pageInfo {
          hasNextPage
          endCursor
        }
      }
    }
  """,
};
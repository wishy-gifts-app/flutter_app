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
            size
            color
            material
            style
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
  'getLikedProducts': """
    query getLikedProducts(
      \$limit: Int!,
      \$cursor: String,
      \$is_like: Boolean!,
    ) {
      getLikedProducts(
        limit: \$limit,
        cursor: \$cursor,
        is_like: \$is_like
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
            size
            color
            material
            style
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
  'saveLike': """
    mutation saveLike(
      \$product_id: Int!,    
      \$user_id: Int!,
      \$is_like: Boolean!
    ) {
      saveLike(product_id: \$product_id, user_id: \$user_id, is_like: \$is_like) {
        id
      }
    }
"""
};

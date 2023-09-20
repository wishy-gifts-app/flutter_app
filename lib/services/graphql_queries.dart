const Map<String, String> graphqlQueries = {
  'updateUserById': """
    mutation updateUserById(
      \$id: Int!,    
      \$phone_number: String,
      \$name: String,
      \$email: String,
      \$gender: String,
      \$birthday: Date
    ) {
      updateUserById(
        id: \$id,
        phone_number: \$phone_number,
        name: \$name,
        email: \$email,
        gender: \$gender,
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
          is_like
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
          is_like
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
  'getUserOrders': """
    query getUserOrders(
      \$limit: Int!,
      \$cursor: String,
      \$is_order_completed: Boolean!,
    ) {
      getUserOrders(
        limit: \$limit,
        cursor: \$cursor,
        is_order_completed: \$is_order_completed
      ) {
        results {
          id,
          user_id,
          product_id,
          variant_id,
          recipient_user_id,
          recipient_user_name,
          for_date,
          price,
          is_order_completed,
          is_order_approved,
          is_in_delivery,
          product {          
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
""",
  'saveOrder': """
    mutation saveOrder(
      \$product_id: Int!, 
      \$variant_id: Int!, 
      \$user_id: Int!,
    ) {
      saveOrder(product_id: \$product_id, user_id: \$user_id, variant_id: \$variant_id) {
        id
      }
    }
""",
  'updateOrderById': """
    mutation updateOrderById(
      \$id: Int!,    
      \$recipient_user_id: Int,
      \$price: Int,
      \$is_order_completed: Boolean,
      \$for_date: Date,
    ) {
      updateOrderById(id: \$id, is_order_completed: \$is_order_completed, price: \$price, for_date: \$for_date) {
        id
      }
    }
""",
  'saveUserAddress': """
    mutation saveUserAddress(
      \$user_id: Int!,
      \$country: String!,
      \$state: String!,
      \$city: String!,
      \$street_address: String!,
      \$street_number: String!,
      \$zip_code: String!,
      \$apartment: String,
      \$extra_details: String,
    ) {
      saveUserAddress(user_id: \$user_id, country: \$country, state: \$state, city: \$city, zip_code: \$zip_code,
      street_address: \$street_address, street_number: \$street_number, apartment: \$apartment, extra_details: \$extra_details ) {
        id
      }
    }
""",
  'getUserAddresses': """
    query getUserAddresses(
      \$limit: Int!,
      \$cursor: String,
    ) {
      getUserAddresses(limit: \$limit, cursor: \$cursor) {
        results {
          id
          country
          state
          city
          zip_code
          street_address
          street_number
          apartment
          extra_details
        }
        pageInfo {
          hasNextPage
          endCursor
        }
      }
    }
""",
  'userById': """
    query userById(
      \$id: Int!
    ) {
      userById(id: \$id) {
        id
        name
        phone_number
        email
    }
  }
""",
  'checkoutHandler': """
    mutation checkoutHandler(
      \$variant_id: Int!,
      \$address_id: Int!,
      \$quantity: Int!,
    ) {
      checkoutHandler(variant_id: \$variant_id, address_id: \$address_id, quantity: \$quantity) {
        payment_url
      }
    }
""",
};

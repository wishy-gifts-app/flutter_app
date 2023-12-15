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
      \$cursor: String,
      \$tag_id: Int
    ) {
      getProductsFeed(
        limit: \$limit,
        cursor: \$cursor,
        tag_id: \$tag_id
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
          is_available
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
          is_available
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
  'getMatchedProducts': """
    query getMatchedProducts(
      \$limit: Int!,
      \$cursor: String,
    ) {
      getMatchedProducts(
        limit: \$limit,
        cursor: \$cursor,
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
          follower_id
          follower_name
          is_available
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
      \$user_id: Int,
      \$name: String,
      \$phone_number: String,
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
      street_address: \$street_address, street_number: \$street_number, apartment: \$apartment, 
      extra_details: \$extra_details, name: \$name, phone_number: \$phone_number ) {
        id
        user_id
      }
    }
""",
  'getUserAddresses': """
    query getUserAddresses(
      \$limit: Int!,
      \$cursor: String,
      \$user_id: Int!,
    ) {
      getUserAddresses(limit: \$limit, cursor: \$cursor, user_id: \$user_id) {
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
  'searchForFollower': """
    query searchForFollower(
      \$limit: Int!,
      \$searchTerm: String!
    ) {
      searchForFollower(limit: \$limit, search_term: \$searchTerm) {
        id
        name
        phone_number
    }
  }
""",
  'isUserActive': """
    query isUserActive(
      \$id: Int!,
      \$is_active_user: Boolean!,
    ) {
      isUserActive(id: \$id, is_active_user: \$is_active_user) {
        result
    }
  }
""",
  'checkoutHandler': """
    mutation checkoutHandler(
      \$variant_id: Int!,
      \$quantity: Int!,
      \$address_id: Int!,
      \$recipient_id: Int,
    ) {
      checkoutHandler(variant_id: \$variant_id, quantity: \$quantity, address_id: \$address_id, recipient_id: \$recipient_id) {
        payment_url
      }
    }
""",
  'requestProduct': """
    mutation requestProduct(
      \$variant_id: Int!,
      \$product_id: Int!,
      \$reason: String!,
      \$recipient_id: Int,
      \$name: String,
      \$phone_number: String,
    ) {
      requestProduct(variant_id: \$variant_id, product_id: \$product_id, reason: \$reason, recipient_id: \$recipient_id, name: \$name, phone_number: \$phone_number) {
        id
      }
    }
""",
  'getUserRequests': """
    query getUserRequests(
      \$limit: Int!,
      \$cursor: String,
    ) {
      getUserRequests(
        limit: \$limit,
        cursor: \$cursor,
      ) {
        results {
          id,
          reason,
          created_at,
          product_id,
          variant_id,
          requester_id,
          recipient_id,
          other_user_name,
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
  'startSupport': """
    query startSupport(
      \$limit: Int!,
      \$cursor: String,
    ) {
      startSupport(
        limit: \$limit,
        cursor: \$cursor,
      ) {
        results {
          id,
          message,
          displayed_at,
          is_consultant,
          is_end_chat,
          user_id
        }
        pageInfo {
          hasNextPage
          endCursor
        }
      }
    }
  """,
  'getAllTags': """
    query getAllTags(
      \$limit: Int!,
      \$cursor: String,
    ) {
      getAllTags(
        limit: \$limit,
        cursor: \$cursor,
      ) {
        results {
          id,
          value,
        }
        pageInfo {
          hasNextPage
          endCursor
        }
      }
    }
  """,
  'getInteractiveCardByType': """
    query getInteractiveCardByType(
      \$type: String!,
    ) {
      getInteractiveCardByType(
        type: \$type,
      ) {
        id
        type
        question
        products_count_trigger
        background_image_path
        additional_data
      }
    }
  """,
  'updateRequestById': """
    mutation updateRequestById(
      \$id: Int!,    
      \$show_request: Boolean!,
    ) {
      updateRequestById(
        id: \$id,
        show_request: \$show_request,
      ) {
        id
      }
    }
  """,
  'saveSupportMessage': """
    mutation saveSupportMessage(
      \$user_id: Int!,    
      \$is_consultant: Boolean!,
      \$is_end_chat: Boolean!,
      \$displayed_at: Date!,
      \$message: String!,
    ) {
      saveSupportMessage(
        user_id: \$user_id,
        is_consultant: \$is_consultant,
        is_end_chat: \$is_end_chat,
        displayed_at: \$displayed_at,
        message: \$message,
      ) {
          id,
          message,
          displayed_at,
          is_consultant,
          is_end_chat,
          user_id
      }
    }
  """,
  'updateSupportMessageById': """
    mutation updateSupportMessageById(
      \$id: Int!,  
      \$displayed_at: Date!,  
    ) {
      updateSupportMessageById(
        id: \$id,
        displayed_at: \$displayed_at,
      ) {
          id,
      }
    }
  """,
  'updateMatchById': """
    mutation updateMatchById(
      \$id: Int!,  
      \$displayed_at: Date!,  
    ) {
      updateMatchById(
        id: \$id,
        displayed_at: \$displayed_at,
      ) {
          id,
      }
    }
  """,
  'isProductAvailable': """
    query isProductAvailable {
      isProductAvailable {
        is_product_available
        user_country
      }
    }
  """,
  'userHasNewMessages': """
    query userHasNewMessages {
      userHasNewMessages {
        user_has_new_messages
      }
    }
  """,
  'userHasNewMatches': """
    query userHasNewMatches {
      userHasNewMatches {
        user_has_new_matches
      }
    }
  """,
};

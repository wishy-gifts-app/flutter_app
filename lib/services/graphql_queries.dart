const Map<String, String> graphqlQueries = {
  'updateUserById': """
    mutation updateUserById(
      \$id: Int!,    
      \$phone_number: String,
      \$name: String,
      \$email: String,
      \$gender: String,
      \$birthday: Date,
      \$fcm_token: String,
      \$notification_available: Boolean,
    ) {
      updateUserById(
        id: \$id,
        phone_number: \$phone_number,
        name: \$name,
        email: \$email,
        gender: \$gender,
        birthday: \$birthday
        fcm_token: \$fcm_token
        notification_available: \$notification_available
      ) {
        id
      }
    }
  """,
  'getProductsFeed': """
    query getProductsFeed(
      \$limit: Int!,
      \$skip: Int
      \$cursor: String,
      \$tag_id: Int
      \$start_id: Int
    ) {
      getProductsFeed(
        limit: \$limit,
        skip: \$skip,
        cursor: \$cursor,
        tag_id: \$tag_id
        start_id: \$start_id
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
          liked_by_user_name
          variants {
            id
            title
            weight
            price
            inventory_quantity
            size
            color
            color_name
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
      \$skip: Int
      \$cursor: String,
      \$is_like: Boolean!,
    ) {
      getLikedProducts(
        limit: \$limit,
        skip: \$skip,
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
            color_name
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
      \$skip: Int
      \$cursor: String,
    ) {
      getMatchedProducts(
        limit: \$limit,
        skip: \$skip,
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
            color_name
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
      \$skip: Int
      \$cursor: String,
      \$is_order_completed: Boolean!,
    ) {
      getUserOrders(
        limit: \$limit,
        skip: \$skip,
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
              color_name
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
      \$cursor: String
    ) {
      saveLike(product_id: \$product_id, user_id: \$user_id, is_like: \$is_like,
        cursor: \$cursor) {
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
      \$country_code: String!,
      \$state: String!,
      \$city: String!,
      \$street_address: String!,
      \$street_number: String!,
      \$zip_code: String!,
      \$apartment: String,
      \$extra_details: String,
      \$allow_share: Boolean,
    ) {
      saveUserAddress(user_id: \$user_id, country: \$country, country_code: \$country_code, 
      state: \$state, city: \$city, zip_code: \$zip_code, street_address: \$street_address, 
      street_number: \$street_number, apartment: \$apartment, extra_details: \$extra_details,
       name: \$name, phone_number: \$phone_number, allow_share: \$allow_share ) {
        id
        name
        phone_number
        email
        addresses {
          id
          country
          country_code
          name
          phone_number
          state
          city
          zip_code
          street_address
          street_number
          apartment
          extra_details
          allow_share
          created_user_id
        }
      }
    }
""",
  'getUserAddresses': """
    query getUserAddresses(
      \$limit: Int!,
      \$skip: Int,
      \$cursor: String,
      \$user_id: Int!
    ) {
      getUserAddresses(limit: \$limit,skip:\$skip, cursor: \$cursor, user_id: \$user_id) {
        results {
          id
          country
          country_code
          name
          phone_number
          state
          city
          zip_code
          street_address
          street_number
          apartment
          extra_details
          allow_share
          created_user_id
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
  'getUserDetailsById': """
    query getUserDetailsById(
      \$user_id: Int!
    ) {
      getUserDetailsById(user_id: \$user_id) {
        id
        name
        phone_number
        email
        payment_methods {
          id
          user_id
          method
          last_digits
          payment_id
          last_updated_at
        }
        addresses {
          id
          country
          country_code
          name
          phone_number
          state
          city
          zip_code
          street_address
          street_number
          apartment
          extra_details
          allow_share
          created_user_id
        }
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
  'isPhoneExists': """
    query isPhoneExists(
      \$phone_number: String!,
    ) {
      isPhoneExists(phone_number: \$phone_number) {
        id
        is_active_user
        name
    }
  }
""",
  'saveUserCard': """
    mutation saveUserCard(
      \$type: String!,
      \$user_id: Int!,
      \$card_id: Int!,
      \$displayed_at: Date,
      \$session: String,
      \$trigger_by_server: Boolean,
      \$custom_trigger_id: Int,
    ) {
      saveUserCard(user_id: \$user_id, card_id: \$card_id, type: \$type,
      displayed_at: \$displayed_at, session: \$session, 
      trigger_by_server: \$trigger_by_server, custom_trigger_id:\$custom_trigger_id) {
          id
          user_id
          last_digits
          payment_id
          last_updated_at
      }
    }
""",
  'requestProduct': """
    mutation requestProduct(
      \$variant_id: Int!,
      \$product_id: Int!,
      \$reason: String,
      \$recipient_id: Int,
      \$name: String,
      \$phone_number: String,
      \$cursor: String,
    ) {
      requestProduct(variant_id: \$variant_id, product_id: \$product_id, reason: \$reason, 
      recipient_id: \$recipient_id, name: \$name, phone_number: \$phone_number, cursor: \$cursor) {
        id
      }
    }
""",
  'getUserRequests': """
    query getUserRequests(
      \$limit: Int!,
      \$skip: Int
      \$cursor: String,
    ) {
      getUserRequests(
        limit: \$limit,
        skip: \$skip,
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
              color_name
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
      \$is_default: Boolean!,
    ) {
      getInteractiveCardByType(
        type: \$type,
        is_default: \$is_default,
      ) {
        id
        type
        question
        products_count_trigger
        background_image_path
        additional_data
        custom_data
        custom_trigger_id
      }
    }
  """,
  'getFeedInteractiveCards': """
    query getFeedInteractiveCards(
      \$start_number: Int!,
      \$end_number: Int!,
      \$old_swipes: Int,
    ) {
      getFeedInteractiveCards(
        start_number: \$start_number,
        end_number: \$end_number,
        old_swipes: \$old_swipes,
      ) {cards {
        id
        type
        question
        products_count_trigger
        background_image_path
        additional_data
        custom_trigger_id
        custom_data
      }}
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
  'getStepsProgressData': """
    query getStepsProgressData {
      getStepsProgressData {
          id
          type
          step_number
          tooltip_text
          is_active
        }
    }
  """,
  'countOldUserSwipes': """
    query countOldUserSwipes(
      \$limit: Int!,
    ) {
      countOldUserSwipes(
        limit: \$limit,
      ) {
          result
        }
    }
  """,
  'setCheckout': """
    mutation setCheckout(
      \$product_id: Int!, \$address_id: Int!, \$price: Float!, \$variant_id: Int!, 
      \$quantity: Int!, \$payment_session: String!, \$cursor: String, \$payment_id: String  
    ) {
      setCheckout(
        product_id: \$product_id, address_id: \$address_id, price: \$price, variant_id: \$variant_id
        quantity: \$quantity, cursor: \$cursor, payment_id: \$payment_id, payment_session: \$payment_session
      ) {
          delivery_time
          delivery_price
          additional_highlights
          sale_tax
          client_secret
          payment_id
          total_price
          pay_amount
        }
    }
  """,
  'saveUserPaymentCard': """
    mutation saveUserPaymentCard(\$payment_id: String!) {
      saveUserPaymentCard(payment_id: \$payment_id) {
          id
        }
    }
  """,
  'interactiveCardHandler': """
    mutation interactiveCardHandler(
      \$id: Int,  
      \$card_id: Int,  
      \$response: JSONObject,  
      \$type: String!,  
      \$displayed_at: String,  
      \$current_cursor: String,  
      \$custom_trigger_id: Int,  
    ) {
      interactiveCardHandler(
        id: \$id,
        card_id: \$card_id,
        response: \$response,
        type: \$type,
        displayed_at: \$displayed_at,
        current_cursor: \$current_cursor,
        custom_trigger_id:\$custom_trigger_id
      ) {
          cursor,
          message,
          connect_user
          connect_user_id
      }
    }
  """,
};

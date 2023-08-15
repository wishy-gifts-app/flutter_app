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
};

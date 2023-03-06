module Mutations
  module User
    class CreateUser < BaseMutation
      # often we will need input types for specific mutation
      # in those cases we can define those input types in the mutation class itself
      class AuthProviderSignupData < Types::BaseInputObject
        argument :credentials, Types::User::AuthProviderCredentialsInput, required: false
      end

      argument :name, String, required: true
      argument :admin, Boolean, required: false
      argument :auth_provider, AuthProviderSignupData, required: false

      type Types::User::UserType

      def resolve(name: nil, admin: nil, auth_provider: nil)
        ::User.create!(
          name: name,
          admin: admin,
          email: auth_provider&.[](:credentials)&.[](:email),
          password: auth_provider&.[](:credentials)&.[](:password)
        )
      end
    end
  end
end

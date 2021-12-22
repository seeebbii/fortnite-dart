import "client.dart";
import "package:fortnite/src/structures/http_response.dart";
import "package:fortnite/resources/endpoints.dart";

class FortniteAuth {
  /// The master client
  late final Client _client;

  FortniteAuth(this._client) {
    _client.log(LogLevel.info, "Fortnite auth module initialized");
  }

  /// Authenticate with the Fortnite API
  dynamic createOAuthToken({
    required String grantType,
    required String grantData,
    String tokenType = "eg1",
    String authClient = "fortniteIOSGameClient",
  }) async {
    HttpResponse res = await _client.http.post(
      url: Endpoints().oauthTokenCreate,
      headers: {
        "Authorization": "basic $authClient",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: "grant_type=$grantType&$grantData&token_type=$tokenType",
    );

    if (res.success) {
      return res.data["access_token"];
    } else {
      if (res.error?["errorCode"] ==
          "errors.com.epicgames.account.invalid_account_credentials") {
        throw Exception("Your account credentials are invalid");
      }
      throw Exception(res.error?["errorMessage"] ?? "Unknown error");
    }
  }
}

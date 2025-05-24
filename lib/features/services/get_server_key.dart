// import 'package:googleapis_auth/auth_io.dart';
//
// class GetServerKey {
//   Future<String> getServerKeyToken() async {
//     final scopes = [
//       'https://www.googleapis.com/auth/userinfo.email',
//       'https://www.googleapis.com/auth/firebase.database',
//       'https://www.googleapis.com/auth/firebase.messaging',
//     ];
//
//     final client = await clientViaServiceAccount(
//       ServiceAccountCredentials.fromJson({
//         "type": "service_account",
//         "project_id": "shoppingapp-208ec",
//         "private_key_id": "4abfa8de521249f02ee6b7928df8a5ecd29550cf",
//         "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDvENaHJo7j7jWx\nxjsdlc3873DKRyJ3tcIC2ziUalx+cvsXDcMIbxk2CBylIl8KdMcvXDUrMyB6Az3T\nUNKoUxlNg8pY+JV1dZiJScJ4y6f27KKC7gAUR3PpeeIz0ojNURhDWzkiuEtD1rdy\njvk+ByQYRFcAl4iVA+v0epVQGQqauP2Hcmy0hJbzSD1f4boZ6ciwH3ajHGPbtPBH\nwqud9tAefIFJ/27/pnqAB9dbW74vfIMQHXKpbtDN0U2taEPDyZ8MPy2BAvYslnmb\nz2nuwPSX6eHGHGq0MzwtzQdsbk3cu/H2tTkcMmnIrQ92vJoF2zXM5kALyZ6pdU0r\niWGEziwdAgMBAAECggEAHpRZzJnbBz7OMXo4z5T871C1bbphp0xhj7n458sfH7GX\neqBxBSAo6mdpOppF6/F6FQ3HY0o76j+F5gTdnVhb0TV9aZoKjCbJpy3/KTJrvsMQ\nGo1VB0MIiaHklFpm01R/NQZzLYTDY98QQiAVs6B4Nn5vXo0DlIQW54PSm5dIavfl\ndCvOLRggtBHjkxOhkSxQVyRKeExe4YVQxHayqt4c603CMjM5WyL2OKsli8oAOCpA\nrdqfcX49H+u+4A3bn0XPq79nCIr4Mw68D2rjvOZY948YY+dO+I9sIFT8k16McjtY\nz8Rpjx8QUGR6YAX6kI6CCGoIdLFtvP13xpfQ7HtSoQKBgQD36hV20v7ejODw7AUn\nQSWkWqBehRD2KVE6vw2x5YCCJsqhNzRoLfXTd28cNer5jBh7+gHlODgjjKd1uBbT\nvJxnS0RVygOA25A7qxJb4TPA6qSUfIluavBRHhjllppy8v/SWZsJbAAMkqs6tkb1\n+DRVSzcGsnLe3e16fNRN/F0qJQKBgQD23N/OH6CZlMXLRyXQihqcHuAQbzBfvomg\n5aZ/F96ZK39CMXiOnEzIRSw5Fj8VIZ7RbYdXsRvYdf+GLwM1izWttHzRq4P4ciEs\nQRXimpLLXKYEbH0AgSJIXMcw0Yxm4BdW0qi6SK84fYiSYJ7ZYwisE0HPc5rllpoX\ng2LpzxlMmQKBgQCxSRKEYKqmV7RcVUvyIGJcv/pC3YGdpzpRemK+vtJBQKBS3Xl6\nrrNGv/gTAnPAdPDlZ4mHc8ahlWoDgtvAGvb13xtFBiuvMFRadyGv1sH9yU5caRqW\nfZ7RQ2ameCaG4UMUF8QI3tTCKPiOCd+A8jfqbtkwztfajHXQzAe+pSOyiQKBgQCa\nmnG/0abvCHFngcN4+0T3CY8iO8B79gSTs7+2UOij3M3yUrFB/zlHI6syhXA0d73T\nQ1lD3jOmOSAylTbZTbnsc+DIHzajXjbQVGK0bEILApcmphsTOcySrShCtrnLpAR5\n56ysHeE+67+gjMpvMsq3mcfZeHlF2C/hEfPcoksh4QKBgGRqWNSmSK3PMEf0Yv6f\notJuihTGvzgZxq6owYwwwksi+47G2vOBlvhUyefmlizHYseKlRA6OLkKo1UbCItc\n+911HvtY2eZNfLUZqG3iN1xfzUBCVh///wgYjA1OLvZCWeulWXBZyIhMC9fNjIF9\n3d9TfCFhmb55hEwopCKRD1Mq\n-----END PRIVATE KEY-----\n",
//         "client_email": "firebase-adminsdk-fbsvc@shoppingapp-208ec.iam.gserviceaccount.com",
//         "client_id": "102378704809600814264",
//         "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//         "token_uri": "https://oauth2.googleapis.com/token",
//         "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//         "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40shoppingapp-208ec.iam.gserviceaccount.com",
//         "universe_domain": "googleapis.com"
//       }
//       ),
//       scopes,
//     );
//     final accessServerKey = client.credentials.accessToken.data;
//     return accessServerKey;
//   }
// }

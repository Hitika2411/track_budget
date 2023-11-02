import 'package:gsheets/gsheets.dart';

class googleSheetsApi {
  String transactionName = '', transactionAmount = '', transactionType = '';
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "budget-tracker-403804",
  "private_key_id": "c8f0af5c5cdb62a19071a4ddbaf62a863ebae12b",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCnSxiE87PEK2QL\nCmg05ydpnoes8r4pefYLCO/Oig90uucovFvDawMoBTvHlEaGmCR5gcWz23kX9Y78\nVSW6suEdBv/83OvtTs0Add12vm8quHF0BPyZ9A+B1t0cnKN7MRUidkVg+hfQuIV+\nKq9oIYGWvvOooRsDB5gxR86zV6SSIJ/7BIWxFtfmvjGAksDjfY4yda+Hnm6WhDTt\nsXjwJcbw+XcmdOMAKbSFA8P/m0eAehvijvoWmrStQqtowolhWwoCEmc7rBwXEuHj\npRo0ohq6om216Zhz4P38F92pafzhuxloZNTZlfrsuJYOmfiCtW8LOXaRnOzP/vNL\nm2Mxbz/RAgMBAAECggEABs0IfOUsXnH2IfXFGTt5cHODp/4BSY3d+QJev1qA+Nmd\nSpxnrZjU2sRlsv4d5NxcBT2HlEF8mYL/0lXC0CVz/dpaP0Ua6T2OG3HvNCPXQJkZ\ncaI/Q6H2nGxn9kEO61PqPEmrFd9s5u0NbjzdfyH3kvGF1cng331oTD6TUlqig9cz\nQIA1kzE2h43qJFN6KPuxKLkjigyLXCIKamhj8QpwgvtHBRKi9H3W9dJ8zSUZ9r5B\nZrB5Qs6fXneR0YV2vezeTy44Yo66oba83a/7TK+giA095wc7KoYfDbnDdBcIDW2y\n9hcCCwQlhQEOzfgNFTo7EW1WL8p4vLP1I3OjaukQ0QKBgQDovw/jNKn6mWzHSOgW\ntYpazc2SR3/tTeIs4ILmAo2JUylFHyVDFDlp20nHtayODpA5/kGD2cD0opjSMLOu\n1RrXrWI3roWF+A1RLoOXW7yl/WPXjAYIZ7DueQat1m5iYql8WWzxHNLDrlDOjlzW\nijcCGOnbkXFCsZZV4BELNQKvmQKBgQC4AfJej9rvVzhp1YCUd7YHFMebCNAhd8Xw\nd5GneSwvjBr/w/BgLfheGuXo0YVOcWNYu5kD3fnNY586O/JKYT2/dDnZJHPxPcIU\nmCCTVYc+6c1484PLEZClCcZXf4hbfbkzMNeLJIrbd1RdM7gkqIsUpr9kUJqwwYu5\n2Ld+P36U+QKBgQDWgMAztiWyQBRw1lCQHWAVr/b2Cc9s9YqtsXzyXwfyuCIhAkNl\nPw5q8R9eX6FYizOBP0NCMT4UOIZ/sULorp6+h50tlDqa7bHYT/YXWQTUNmP+E567\nwFTgc8okDKxPIH7zi7dLwDS/A7iVpb8KOvfXhv6AzdqEjQbwvkD3AzQmgQKBgFQ0\nl9yMSm1y5Z8RFDldGxDcgofBHbXjINLtdNtGCWFs5UIcQZlSEDHIb2P+1dlS7FrD\n5r8tSs6iA1Db9AHzxBUkNADZvLEuSO2xvF6QKkcxKVVrYumADUhpU7ng496yhxkV\nBd5oB59tWU8ZhvBHrPXzZOycMl4nBDE1Kqt8lQnJAoGAQ/RcgtUzbmgo5I0VhlGk\nb99Q4qFFBaVrzgCFeRSNqNwMX+vjBsSlYLRIBsjl7G7rzRSSLrcgkd8jp47HoMaH\njU3kAaoX6Nnflu8sW0KCUoz7qqk/cnBV7qrl8QeTwxfh3t99cMZzwJUQCIA0ZX6t\nCFaiPzmfY3TRD1ZM9hZs9Lk=\n-----END PRIVATE KEY-----\n",
  "client_email": "budget-tracker@budget-tracker-403804.iam.gserviceaccount.com",
  "client_id": "107593955530991894635",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/budget-tracker%40budget-tracker-403804.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';
  static final _spreadsheetId = '1pul1wtYek8pyXcyaq5-tg10FmEaa8z6mShsCGQe--1A';
  static final gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;
  Future init() async {
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Sheet1');
    countRows();
  }

  //count the number of rows
  Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    loadTransactions();
  }

  Future loadTransactions() async {
    if (_worksheet == null) return;
    for (int i = 1; i < numberOfTransactions; i++) {
      transactionName = await _worksheet!.values.value(column: 1, row: i + 1);
      transactionAmount = await _worksheet!.values.value(column: 2, row: i + 1);
      transactionType = await _worksheet!.values.value(column: 3, row: i + 1);
      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    loading = false;
  }

  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([name, amount, _isIncome ? 'income' : 'expense']);
    await _worksheet!.values
        .appendRow([name, amount, _isIncome ? 'income' : 'expense']);
  }

  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }

  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }
}

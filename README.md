# 강의 레포
[Flutter Repo](https://github.com/codefactory-co/flutter-lv2-rest-api)
[Server Repo](https://github.com/codefactory-co/flutter-lv2-server)

# Code snippet
```
"JsonSerializable fromJson": {
		"prefix": "FJ",
		"body": [
			"factory $1.fromJson(final Map<String, dynamic> json) => _$$1FromJson(json);"
		],
		"description": "fromJson 편하가 만들기"
	},

	"Model Property & Create init": {
		"prefix": "MC",
		"body": [
			"class $1 {",
			"final String $2;",
			"final String $3;",
			"final String $4;",
			"final String $5;",
			"final String $6;",
			"final String $7;",
			"final String $8;",
			"final String $9;",
			"$1({",
			
			"required this.$2,",
			"required this.$3,",
			"required this.$4,",
			"required this.$5,",
			"required this.$6,",
			"required this.$7,",
			"required this.$8,",
			"required this.$9,",
			"});",
			"}"
		]
	}			
```
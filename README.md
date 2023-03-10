# 강의 레포

[Flutter Repo](https://github.com/codefactory-co/flutter-lv2-rest-api)
[Server Repo](https://github.com/codefactory-co/flutter-lv2-server)

# Code snippet
```

{
	// Place your snippets for dart here. Each snippet is defined under a snippet name and has a prefix, body and 
	// description. The prefix is what is used to trigger the snippet and the body will be expanded and inserted. Possible variables are:
	// $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. Placeholders with the 
	// same ids are connected.
	// Example:
	"JsonSerializable fromJson": {
		"prefix": "snippet add fromJson",
		"body": [
			"factory $1.fromJson(final Map<String, dynamic> json) => _$$1FromJson(json);"
		],
		"description": "fromJson 편하게 만들기"
	},

	"Create model property & create init": {
		"prefix": "snippet create model",
		"body": [
			"import 'package:json_annotation/json_annotation.dart';",
			"@JsonSerializable()",
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
			
			"factory $1.fromJson(final Map<String, dynamic> json) => _$$1FromJson(json);",
			"Map<String, dynamic> toJson() => _$$1ToJson(this);",
			"}"
		]
	},
	
	"Create general paginated repository": {
		"prefix": "snippet create paginated repository",
		"body": [
			"part '$4.g.dart';",

			"final $3RepositoryProvider = Provider<$1Repository>((ref) {",
			  "final dio = ref.watch(dioProvider);",
			
			  "return $1Repository(dio, baseUrl: '$2');",
			"});",
			
			"@RestApi()",
			"abstract class $1Repository implements IBasePaginationRepository<$1Model> {",
			  "factory $1Repository(Dio dio, {String baseUrl}) = _$1Repository;",
			
			  "@GET('/')",
			  "@Headers({'accessToken': 'true'})",
			  "Future<CursorPagination<$1Model>> paginate({",
				"@Queries() PaginationParams? paginationParams = const PaginationParams(),",
			  "});",
			"}",
		],
		"description": "paginated repository + provider 자동 생성"
	},
}
```
# SQL-string-matchmaker
SQL algorithm to extract a code from string without predefined rules, that matches content in a database table column.

Known problems:
1. Does not work with space separator (example: "SSSS PRODUCTCODE_FS-back.png")
2. Does not work when separators are also part of extracted code (example: SSSS_PRODUCT-CODE_FS-back.png)

The test folder contains one use case of this implementation.
Objective: Extract the product code from the product image files autonously without any predefined rules. The given codes must match the values in the Code column of the Products table, if not returns null.


/**** expected behavior ****/

initial string : NewSeason_CI9152-010_FS_back.png

product code : CI9152-010

intermediate split outputs :

| ElementID_a	| Element_a	| ElementID_b	| Element_b	| ElementID_c	| Element_c	| ElementID_d	| Element_d	| FinalElement|
|-------------|-----------|-------------|-----------|-------------|-----------|-------------|-----------|-------------|
| 1		| NewSeason	| 1		| NewSeason	| 1		| NewSeason	| 1		| NewSeason	| NewSeason
| 2		| CI9152-010	| 1		| CI9152-010	| 1		| CI9152-010	| 1		| CI9152		| CI9152
| 2		| CI9152-010	| 1		| CI9152-010	| 1		| CI9152-010	| 2		| 010		| 010
| 3		| FS		| 1		| FS		| 1		| FS		| 1		| FS		| FS
| 4		| back.png	| 1		| back.png	| 1		| back		| 1		| back		| back
| 4		| back.png	| 1		| back.png	| 2		| png		| 1		| png		| png

final result : CI9152-010

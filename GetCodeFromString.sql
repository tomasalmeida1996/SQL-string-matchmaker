/*
known poblems:
-Does not work with space separator
	 -example: "SSSS PRODUCTCODE_FS-back.png"
-Does not work when separators are also part of extracted code
	 -example: SSSS_PRODUCT-CODE_FS-back.png
*/

declare @tableFiles table (idfile int identity(1,1), [filename] nvarchar(100))
insert into @tableFiles values
('New&Season_DX8938-FS_back.png'),
('NewSeason_CI9152-010_FS_back.png'),
('New&Season&1212BORDADO-AZ_back.png'),
('New&Season&999999_back.png')


/********************* select for filename decision tree *********************/
select *,replace([filename],' ',''),(
select top 1 
case 
		when Delement is null and Celement is null and Belement is null then Aelement
		when Delement is null and Celement is null then Belement
		when Delement is null then Celement
		else Delement
		end CodeElement--,
		--*
from (
select 
case when a.element in (select codigo from artigos) then a.element  else null end Aelement,
case when b.element in (select codigo from artigos) then b.element  else null end Belement,
case when c.element in (select codigo from artigos) then c.element  else null end Celement,
case when d.element in (select codigo from artigos) then d.element  else null end Delement

from SplitString(replace([filename],' ',''),'_') a
cross apply SplitString(a.element,'&') b
cross apply SplitString(b.element,'.') c
cross apply SplitString(c.element,'-') d
) as T
where Delement is not null or Celement is not null or Belement is not null or Aelement is not null
) ProductCode from @tableFiles


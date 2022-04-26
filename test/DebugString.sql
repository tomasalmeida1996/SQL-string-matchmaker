declare @filename nvarchar(100) = 'NewSeason_CI9152-010_FS_back.png'

/**** expected behavior ****/
/*
initial string: NewSeason_CI9152-010_FS_back.png
product code : CI9152-010

intermediate split outputs
ElementID_a	Element_a	ElementID_b	Element_b	ElementID_c	Element_c	ElementID_d	Element_d	FinalElement
1		NewSeason	1		NewSeason	1		NewSeason	1		NewSeason	NewSeason
2		CI9152-010	1		CI9152-010	1		CI9152-010	1		CI9152		CI9152
2		CI9152-010	1		CI9152-010	1		CI9152-010	2		010		010
3		FS		1		FS		1		FS		1		FS		FS
4		back.png	1		back.png	1		back		1		back		back
4		back.png	1		back.png	2		png		1		png		png

final result: CI9152-010
*/

/**** multiple stages of split output for string @filename ****/
select *,case 
	when d.element is null and c.element is null and b.element is null then a.element
	when d.element is null and c.element is null then b.element
	when d.element is null then c.element
	else d.element
	end
from SplitString(@filename,'_') a
cross apply SplitString(a.element,'&') b
cross apply SplitString(b.element,'.') c
cross apply SplitString(c.element,'-') d

/**** final result for string @filename ****/
select *,case 
	when d.element is null and c.element is null and b.element is null then a.element
	when d.element is null and c.element is null then b.element
	when d.element is null then c.element
	else d.element
	end
from SplitString(@filename,'_') a
cross apply SplitString(a.element,'&') b
cross apply SplitString(b.element,'.') c
cross apply SplitString(c.element,'-') d
where 
a.element in (select codigo from artigos) OR
b.element in (select codigo from artigos) OR
c.element in (select codigo from artigos) OR
d.element in (select codigo from artigos) 
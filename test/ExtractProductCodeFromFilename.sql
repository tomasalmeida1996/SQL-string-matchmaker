SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ExtractProductCodeFromFilename]
(
@batch int
)
as begin

    /********************* select for filename decision tree *********************/
    Update PII
    set ProductCode=PCodes.ProductCode
    from ProductsImagesImport PII
         inner join(select IdProductsFileImported, (select top 1 case when Delement is null and Celement is null and Belement is null then Aelement
                                                                 when Delement is null and Celement is null then Belement
                                                                 when Delement is null then Celement else Delement end CodeElement
                                                    from(select case when a.element in(select code from Products) then a.element else null end Aelement, case when b.element in(select code from Products) then b.element else null end Belement, case when c.element in(select code from Products) then c.element else null end Celement, case when d.element in(select code from Products) then d.element else null end Delement
                                                         from SplitString(replace([Name], ' ', ''), '_') a
                                                              cross apply SplitString(a.element, '&') b
                                                              cross apply SplitString(b.element, '.') c
                                                              cross apply SplitString(c.element, '-') d ) as T
                                                    where Delement is not null or Celement is not null or Belement is not null or Aelement is not null) ProductCode
                    from ProductsImagesImport) as PCodes on PCodes.IdProductsFileImported = PII.IdProductsFileImported
    where batch=@Batch
end

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT SaleDateConverted
  FROM housing

  update housing 
  set saledate = convert(date, saledate)


  alter table housing 
  add SaleDateConverted date 

  update housing 
  set SaleDateConverted = saledate

  SELECT *
  FROM housing
  --where propertyaddress is null 
  order by parcelid

  
  SELECT a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress, b.propertyaddress)
  from housing a
  join housing b
  on a.parcelid = b.parcelid
  and a.uniqueid <> b.uniqueid 
 where a.propertyaddress is null 


 update a 
 set propertyaddress =  isnull(a.propertyaddress, b.propertyaddress)
   from housing a
  join housing b
  on a.parcelid = b.parcelid
  and a.uniqueid <> b.uniqueid 
 where a.propertyaddress is null 

SELECT *
  FROM housing

  select SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress) -1) as Address,
   SUBSTRING(propertyaddress, charindex(',', propertyaddress) +1, len(propertyaddress)) as Address
   FROM housing

   alter table housing 
  add PropertySplitAddress nvarchar(255)
   alter table housing 
  add PropertySplitCity nvarchar(255)

  update housing 
  set PropertySplitAddress =  SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress) -1) 
  
  update housing 
  set PropertySplitCity = SUBSTRING(propertyaddress, charindex(',', propertyaddress) +1, len(propertyaddress))

 
 select SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress) -1) from housing

 select propertyaddress from housing

 select  charindex(',', propertyaddress)  from housing

 select owneraddress from housing
 
 select
 parsename(replace(owneraddress, ',', '.'), 3),
 parsename(replace(owneraddress, ',', '.'), 2),
 parsename(replace(owneraddress, ',', '.'), 1)
 from housing

 update housing 
  set OwnerSplitAddress = parsename(replace(owneraddress, ',', '.'), 3)

  
 update housing 
  set OwnerSplitCity = parsename(replace(owneraddress, ',', '.'), 2)

 update housing 
  set OwnerSplitState = parsename(replace(owneraddress, ',', '.'), 1)

 select distinct(SoldAsVacant), count(soldasvacant)
 from housing
 group by SoldAsVacant
 order by 2

 select SoldAsVacant ,
 case when soldasvacant = 'y' then 'Yes' 
	when soldasvacant = 'n' then 'No' 
 Else Soldasvacant end as Soldasvacant1
 from housing

 update housing 
 set SoldAsVacant =
  case when soldasvacant = 'y' then 'Yes' 
	when soldasvacant = 'n' then 'No' 
 Else Soldasvacant end
 from housing

 WITH RowNumCTE AS(

  select *, 
  ROW_NUMBER() over 
  (partition by parcelid, 
				 propertyaddress,
				 saleprice, 
				 saledate, 
				 legalreference 
				order by 
				uniqueid) row_num
		from housing 
)
select * from RowNumCTE
  where row_num > 1 


alter table housing 
drop column owneraddress

select * from housing

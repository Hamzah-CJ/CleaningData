


create database Cleaning

--Cleaning the SaleDate column.
select * from Real_Estate
--Convert the Saledate into date data type.
select SaleDate, convert(date,SaleDate) 
from Real_Estate
--Add new column named Converted_Sale_Date with date data type
alter table Real_Estate
add Converted_Sale_Date date
--Copy the converted Saledate data type into the new column.
update Real_Estate
set Converted_Sale_Date = CONVERT(date,Saledate)


--Populate the PropertyAddress Where is NULL

select * from Real_Estate
where PropertyAddress is null

select b.ParcelID,b.PropertyAddress,t.ParcelID,t.PropertyAddress, ISNULL(b.PropertyAddress,t.PropertyAddress)
from Real_Estate b
join Real_Estate t
on b.ParcelID = t.ParcelID
and b.[UniqueID ] <> t.[UniqueID ]
where b.PropertyAddress is null

update b 
set PropertyAddress = ISNULL(b.PropertyAddress,t.PropertyAddress)
from Real_Estate b
join Real_Estate t
on b.ParcelID = t.ParcelID
and b.[UniqueID ] <> t.[UniqueID ]
where b.PropertyAddress is null


--Split the PropertyAddress Column

select PropertyAddress from Real_Estate

select substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress) )as Address2
from Real_Estate

 --Ulter the table and update the columns to the splitted data.

 alter table Real_Estate
add AddressSplit nvarchar(255)
 alter table Real_Estate
add CitySplit nvarchar(255)

update Real_Estate 
set AddressSplit = substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

update Real_Estate 
set CitySplit = substring(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress) )



--Change y and n to 'yes' and 'no' in SoldAsVacant Column

select distinct SoldAsVacant, 
case 
       when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   End
from Real_Estate

update Real_Estate
set SoldAsVacant = case 
       when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   End

select distinct SoldAsVacant
from Real_Estate


--Check for Duplicates and Delete them if found.

select * from Real_Estate
--First do the selection query and put it into CTE so then you can check on the new row_num column after the creation and delete the duplicates.
with raw_numb as 
(
select *, 
       ROW_NUMBER() over(
	   partition by ParcelID,
	                PropertyAddress,
					SaleDate,
					LegalReference
		order by UniqueID) row_num
from Real_Estate
)

delete from raw_numb
 where row_num > 1




-- standardize date format 
select SaleDate, CONVERT(date,Saledate) from 
dbo.Sheet1$

update dbo.Sheet1$
set SaleDate = CONVERT(date,saledate)

alter table dbo.Sheet1$
add salesdateconverted date

update dbo.Sheet1$
set salesdateconverted = CONVERT(date,saledate)

select salesdateconverted
from dbo.Sheet1$


---populate property address data
select a.ParcelID, a.ParcelID, b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.Sheet1$ a 
join dbo.Sheet1$ b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.Sheet1$ a
join dbo.Sheet1$ b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

select * from dbo.Sheet1$

-- seperating city from propertyaddress

select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 , LEN(PropertyAddress)) as Address
from
dbo.Sheet1$


alter table dbo.sheet1$
add PropertySplitAddress nvarchar(255)


update dbo.Sheet1$
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table dbo.sheet1$
add PropertySplitCity nvarchar(255)

update dbo.Sheet1$
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 , LEN(PropertyAddress))

select * from
dbo.Sheet1$

--seperating city and address from owneraddress
select 
PARSENAME(replace(OwnerAddress, ',' , '.'),3),
PARSENAME(replace(OwnerAddress, ',' , '.'),2),
PARSENAME(replace(OwnerAddress, ',' , '.'),1)
from dbo.Sheet1$

ALTER TABLE dbo.sheet1$
add Owneraddresssplit nvarchar(255),
OwnerCity nvarchar(255),
Ownerstate nvarchar(255)

update dbo.Sheet1$
set Owneraddresssplit = PARSENAME(replace(OwnerAddress, ',' , '.'),3)


update dbo.Sheet1$
set OwnerCity = PARSENAME(replace(OwnerAddress, ',' , '.'),2)


update dbo.Sheet1$
set Ownerstate = PARSENAME(replace(OwnerAddress, ',' , '.'),1)

select * from
dbo.Sheet1$


--converting y and n into yes and no in soldasvacant column

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from dbo.Sheet1$
group by SoldAsVacant
order by 2


select SoldAsVacant ,
case when SoldAsVacant = 'Y' then 'YES'
	 when SoldAsVacant = 'N' then 'NO'
	 else SoldAsVacant
	 end
from dbo.Sheet1$

update dbo.Sheet1$
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'YES'
	 when SoldAsVacant = 'N' then 'NO'
	 else SoldAsVacant
	 end

select SoldAsVacant
from dbo.Sheet1$

---- delete unused columns

select *
from dbo.Sheet1$

alter table dbo.sheet1$
drop column PropertyAddress,OwnerAddress,TaxDistrict,SaleDate




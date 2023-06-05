--- Delete unused columns

select *
from PORTFOLIO.dbo.NasvilleHousing

ALTER TABLE PORTFOLIO.dbo.NasvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, SaleDate, TaxDistrict





--- Remove Duplicate

WITH RownumCTE AS(
select *,
         ROW_NUMBER() OVER(
		 PARTITION BY ParcelID,
		              PropertyAddress,
					  SalePrice,
					  SaleDate,
					  LegalReference
		     ORDER BY UniqueID) Row_num



From PORTFOLIO.dbo.NasvilleHousing
--- ORDER BY ParcelID
)
select *
From RownumCTE
Where row_num >1
--- ORDER BY (PropertyAddress)




--- changr y and N  to Yes and No in "sold as vacant" column

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From PORTFOLIO.dbo.NasvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
From PORTFOLIO.dbo.NasvilleHousing

UPDATE PORTFOLIO.dbo.NasvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END








--- Breaking out address into indidvidual columns (address, city, state)


select *
from PORTFOLIO.dbo.NasvilleHousing

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS City

from PORTFOLIO.dbo.NasvilleHousing



ALTER TABLE PORTFOLIO.dbo.NasvilleHousing
Add propertysplitaddress Nvarchar(255);

UPDATE  PORTFOLIO.dbo.NasvilleHousing
Set PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE PORTFOLIO.dbo.NasvilleHousing
ADD propertysplitcity Nvarchar(255);

UPDATE PORTFOLIO.dbo.NasvilleHousing
SET PropertysplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))



select OwnerAddress
from PORTFOLIO.dbo.NasvilleHousing


select 
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
From PORTFOLIO.dbo.NasvilleHousing



ALTER TABLE PORTFOLIO.dbo.NasvilleHousing
Add OwnersplitAddress Nvarchar(255);

UPDATE  PORTFOLIO.dbo.NasvilleHousing
SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)


ALTER TABLE PORTFOLIO.dbo.NasvilleHousing
ADD OwnersplitCity Nvarchar(255);

UPDATE PORTFOLIO.dbo.NasvilleHousing
SET OwnersplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

ALTER TABLE PORTFOLIO.dbo.NasvilleHousing
ADD OwnersplitState Nvarchar(255);

UPDATE PORTFOLIO.dbo.NasvilleHousing
SET OwnersplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)





--- populate property address data

select *
from PORTFOLIO.dbo.NasvilleHousing
where PropertyAddress is null

--- using self join to populate property address


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) AS PROPERTY2
from PORTFOLIO.dbo.NasvilleHousing a
JOIN PORTFOLIO.dbo.NasvilleHousing b
ON a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set propertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PORTFOLIO.dbo.NasvilleHousing a
JOIN PORTFOLIO.dbo.NasvilleHousing b
ON a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]


------------------------------------------------------------------------------------------------------------------------------
-- Standardized date format

select saledateformatted, convert(date,saledate)
from PORTFOLIO.dbo.NasvilleHousing	


ALTER TABLE PORTFOLIO.dbo.NasvilleHousing
Add saledateformatted date;

UPDATE PORTFOLIO.dbo.NasvilleHousing
Set saledateformatted = convert(date, saledate)

-- Cleaning data in SQL Querie
select*
from PORTFOLIO.dbo.NasvilleHousing		
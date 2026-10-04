/*

Cleaning Data in SQL Queries
*/

Select SaleDate
From PortfoliProject..NashvilleHousing
------------------------------------------------------------------------------------------------------------

--Standardize date format 

Select SaleDateConverted
From PortfoliProject..NashvilleHousing

UPDATE PortfoliProject..NashvilleHousing
SET SaleDate =CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDataConverted Date;


UPDATE PortfoliProject..NashvilleHousing
SET SaleDataConverted =CONVERT(Date,SaleDate)





------------------------------------------------------------------------------------------------------------
--Populate Property Address data

Select *
From PortfoliProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.propertyAddress,b.PropertyAddress)
From PortfoliProject..NashvilleHousing a
join PortfoliProject..NashvilleHousing b
    on a.ParcelID=b.ParcelID
    AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


UPDATE a
SET PropertyAddress=ISNULL(a.propertyAddress,b.PropertyAddress)
From PortfoliProject..NashvilleHousing a
join PortfoliProject..NashvilleHousing b
    on a.ParcelID=b.ParcelID
    AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-------------------------------------------------------------------------------------------------------------
-- Breaking out Address into individual Columns (Address,City,State)

Select PropertyAddress
From PortfoliProject..NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address


FROM PortfoliProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);


UPDATE PortfoliProject..NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);


UPDATE PortfoliProject..NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 

Select *
FROM PortfoliProject..NashvilleHousing


Select OwnerAddress
FROM PortfoliProject..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfoliProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);


UPDATE PortfoliProject..NashvilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);


UPDATE PortfoliProject..NashvilleHousing
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);


UPDATE PortfoliProject..NashvilleHousing
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select *
From PortfoliProject..NashvilleHousing


ALTER TABLE  NashvilleHousing
DROP COLUMN OwnerSplitSate

Select Distinct(SoldAsVacant) ,count(SoldAsVacant)
From PortfoliProject..NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
,CASE WHEN SoldAsVacant='Y' THEN 'Yes'
      WHEN SoldAsVacant='N' THEN 'No' 
      ELSE SoldAsVacant
      END
From PortfoliProject..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant=CASE WHEN SoldAsVacant='Y' THEN 'Yes'
      WHEN SoldAsVacant='N' THEN 'No' 
      ELSE SoldAsVacant
      END
------------------------------------------------------------------------------------------------------------

--Remove duplicates 
WITH RowNumCTE AS
(
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID,
                            PropertyAddress,
                            SalePrice,
                            SaleDate,
                            LegalReference
               ORDER BY UniqueID
           ) AS row_num
    FROM PortfoliProject..NashvilleHousing
)

SELECT *
FROM RowNumCTE
WHERE row_num>1
--Order by PropertyAddress

Select *
From PortfoliProject..NashvilleHousing

------------------------------------------------------------------------------------------------------------

--Delete Unused Column

Select *
From PortfoliProject..NashvilleHousing

ALTER TABLE PortfoliProject..NashvilleHousing 
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE PortfoliProject..NashvilleHousing 
DROP COLUMN SaleDate
--HOUSING CLEANING DATA

select *
from HousingProject..NashvilleHousing



--Standardized date formats

Select SaleDate, CONVERT(Date,SaleDate)
From HousingProject..NashvilleHousing


ALTER TABLE HousingProject..NashvilleHousing
Add SaleDateConv Date;

Update HousingProject..NashvilleHousing
SET SaleDateConv = CONVERT(Date,SaleDate)


Select SaleDateConv, CONVERT(Date,SaleDate)
From HousingProject..NashvilleHousing

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From HousingProject..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From HousingProject..NashvilleHousing a
JOIN HousingProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From HousingProject..NashvilleHousing a
JOIN HousingProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From HousingProject..NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

--Using Substring and Charindex

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From HousingProject..NashvilleHousing


ALTER TABLE HousingProject..NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update HousingProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

--Using Parsename

SELECT 
PARSENAME(REPLACE(PropertyAddress, ',', '.') , 2),
PARSENAME(REPLACE(PropertyAddress, ',', '.') , 1)
From HousingProject..NashvilleHousing 

ALTER TABLE HousingProject..NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update HousingProject..NashvilleHousing
SET PropertySplitCity = PARSENAME(REPLACE(PropertyAddress, ',', '.') , 1)


Select *
From HousingProject..NashvilleHousing

--Splitting Owner's Address

Select OwnerAddress
From HousingProject..NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From HousingProject..NashvilleHousing


ALTER TABLE HousingProject..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update HousingProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE HousingProject..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update HousingProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE HousingProject..NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update HousingProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From HousingProject..NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Solid as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From HousingProject..NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From HousingProject..NashvilleHousing


Update HousingProject..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From HousingProject..NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From HousingProject..NashvilleHousing


ALTER TABLE HousingProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate




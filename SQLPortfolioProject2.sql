
--Standardized Date Format
Select SaleDate, CAST(SaleDate AS date) AS Date 
From NashvilleHousing

Alter Table NashvilleHousing
Alter Column SaleDate date

Select SaleDate 
From NashvilleHousing

--Populate Property Address Data
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) AS NEW_P_A
From NashvilleHousing as a 
JOIN NashvilleHousing as b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing as a 
JOIN NashvilleHousing as b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking Out Address Into Individual Columns(Address, City, State)
Select PropertyAddress
From NashvilleHousing

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
From NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(300)

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)
From NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(300)

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))
From NashvilleHousing

Select *
From NashvilleHousing


Select PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS State
From NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(300)

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 
From NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(300)

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) 
From NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(300)

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) 
From NashvilleHousing

Select OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
From NashvilleHousing


--Replacing Y and N with Yes and No

Select REPLACE(SoldAsVacant, 'Y', 'Yes')
From NashvilleHousing
Where SoldAsVacant = 'Y'

Update NashvilleHousing
Set SoldAsVacant = REPLACE(SoldAsVacant, 'Y', 'Yes')
From NashvilleHousing
Where SoldAsVacant = 'Y'

Update NashvilleHousing
Set SoldAsVacant = REPLACE(SoldAsVacant, 'N', 'No')
From NashvilleHousing
Where SoldAsVacant = 'N'

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group By SoldAsVacant


--Remove Duplicates
WITH RowNumCTE AS(
Select *, ROW_NUMBER() Over(Partition By ParcelID,
										 PropertyAddress,
										 SaleDate,
										 SalePrice,
										 LegalReference
										 Order By UniqueID
										 ) AS Row_Number
From NashvilleHousing
)
Select *
From RowNumCTE
Where Row_Number > 1


Select * 
From NashvilleHousing


--Deleting Unused Columns

Alter Table NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Select * 
From NashvilleHousing
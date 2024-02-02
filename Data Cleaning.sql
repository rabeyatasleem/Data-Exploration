Select *
From PortfolioProject.dbo.[Nashville Housing]

-- Standardize Date Format
ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update [Nashville Housing]
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate Property Address data

Select *
From PortfolioProject.dbo.[Nashville Housing]
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.[Nashville Housing] a
JOIN PortfolioProject.dbo.[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.[Nashville Housing] a
JOIN PortfolioProject.dbo.[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.[Nashville Housing]
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.[Nashville Housing]


ALTER TABLE [Nashville Housing]
Add PropertySplitAddress Nvarchar(255);

Update [Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Nashville Housing]
Add PropertySplitCity Nvarchar(255);

Update [Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.[Nashville Housing]

Select OwnerAddress
From PortfolioProject.dbo.[Nashville Housing]

-- change Y and N to Yes and No in "Sold as vacant" field
Select Distinct (SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject.dbo.[Nashville Housing]
group by SoldAsVacant


UPDATE [Nashville Housing]
SET SoldAsVacant =  CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant
	END
from PortfolioProject..[Nashville Housing]

-- remove duplicates
Select *
from PortfolioProject..[Nashville Housing]

With CTE AS(
Select *,
row_number() OVER  (
partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			Order by UniqueID
) row_number
from PortfolioProject..[Nashville Housing]
)

Select * from CTE
where row_number >1
order by PropertyAddress

Delete from CTE
where row_number >1

-- Delete Unused Columns

Select *
From PortfolioProject.dbo.[Nashville Housing]

ALTER TABLE PortfolioProject.dbo.[Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

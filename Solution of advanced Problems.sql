-- 32. High-value customers (NO OUTPUT)
		SELECT C.CustomerID , CompanyName, O.OrderID ,
		SUM(UnitPrice * Quantity) "TotalOrderAmount"
		FROM Customers C, Orders O ,  [Order Details] OD
		WHERE C.CustomerID = O.CustomerID
		AND O.OrderID = OD.Discount
		AND OrderDate >= '20160101'and OrderDate < '20170101'
		GROUP BY C.CustomerID , CompanyName, O.OrderID
		HAVING SUM(UnitPrice * Quantity) > 10000
		ORDER BY TotalOrderAmount DESC

-- 33. High-value customers - total orders (NO OUTPUT)
		SELECT C.CustomerID , CompanyName, 
		SUM(UnitPrice * Quantity) "TotalOrderAmount"
		FROM Customers C, Orders O ,  [Order Details] OD
		WHERE C.CustomerID = O.CustomerID
		AND O.OrderID = OD.Discount
		AND OrderDate >= '20160101'and OrderDate < '20170101'
		GROUP BY C.CustomerID , CompanyName
		HAVING SUM(UnitPrice * Quantity) > 15000
		ORDER BY TotalOrderAmount DESC

-- 34. High-value customers - with discount (NO OUTPUT)
		SELECT C.CustomerID , CompanyName, O.OrderID ,
		SUM(UnitPrice * Quantity * (1- Discount)) "TotalOrderAmount"
		FROM Customers C, Orders O ,  [Order Details] OD
		WHERE C.CustomerID = O.CustomerID
		AND O.OrderID = OD.Discount
		AND OrderDate >= '20160101'and OrderDate < '20170101'
		GROUP BY C.CustomerID , CompanyName
		HAVING SUM(UnitPrice * Quantity * (1- Discount)) > 10000
		ORDER BY TotalOrderAmount DESC
		
-- 35. Month-end orders
		SELECT EmployeeID ,OrderID ,OrderDate
		FROM Orders
		WHERE OrderDate = EOMONTH(OrderDate)
		ORDER BY EmployeeID ,OrderID

-- 36. Orders with many line items
		SELECT orders.OrderID, COUNT(*) TotalOrderDetails
		FROM Orders, [Order Details] O
		WHERE Orders.OrderID = O.OrderID
		Group By Orders.OrderID
		Order By count(*) desc

-- 37. Orders - random assortment
		SELECT TOP(2)  PERCENT orderid
		FROM Orders
		ORDER BY newid()

-- 38. Orders - accidental double-entry
		SELECT OrderID
		FROM [Order Details]
		WHERE Quantity >= 60
		GROUP BY OrderID ,Quantity
		HAVING Count(*) > 1

-- 40. Orders - accidental double-entry details, derived table
		SELECT [Order Details].OrderID ,ProductID, UnitPrice,
		Quantity, Discount
		FROM [Order Details] Join ( Select distinct OrderID
		FROM [Order Details]
		WHERE Quantity >= 60
		GROUP BY OrderID, Quantity
		HAVING Count(*) > 1 ) PotentialProblemOrders
		ON PotentialProblemOrders.OrderID =[Order Details].OrderID

-- 41. Late orders 
		SELECT OrderID, convert(date, OrderDate) OrderDate,
		convert(date, RequiredDate)RequiredDate,
		convert(date, ShippedDate ) ShippedDate 
		FROM Orders
		WHERE RequiredDate <= ShippedDate

-- 42. Late orders - which employees?
		SELECT Employees.EmployeeID, LastName,
		COUNT(*) TotalLateOrders 
		FROM Orders, Employees
		Where Employees.EmployeeID = Orders.EmployeeID
		AND
		RequiredDate <= ShippedDate
		Group By Employees.EmployeeID ,Employees.LastName
		Order by TotalLateOrders desc
			   
-- 43. Late orders vs. total orders
		WITH LateOrders AS(
		SELECT EmployeeID,Count(*)  TotalOrders
		From Orders
		Where RequiredDate <=ShippedDate
		Group By EmployeeID),
		AllOrders AS(
		SELECT EmployeeID,Count(*)  TotalOrders
		From Orders Group By
		EmployeeID)
		SELECT Employees.EmployeeID, 
		AllOrders.TotalOrders "AllOrders",
		LateOrders.TotalOrders "LateOrders"
		From Employees Join AllOrders
		ON
		AllOrders.EmployeeID = Employees.EmployeeID
		Join LateOrders 
		ON LateOrders.EmployeeID = Employees.EmployeeID


-- 44. Late orders vs. total orders - missing employee
		WITH LateOrders AS(
		SELECT EmployeeID,Count(*)  TotalOrders
		From Orders
		Where RequiredDate <=ShippedDate
		Group By EmployeeID),
		AllOrders AS(
		SELECT EmployeeID,Count(*)  TotalOrders
		From Orders Group By
		EmployeeID)
		SELECT Employees.EmployeeID,
		LastName, AllOrders.TotalOrders "AllOrders",
		LateOrders.TotalOrders "LateOrders"
		FROM Employees Join AllOrders
		ON
		AllOrders.EmployeeID = Employees.EmployeeID
		Left Join LateOrders
		ON LateOrders.EmployeeID = Employees.EmployeeID

-- 45. Late orders vs. total orders - fix null
		WITH LateOrders AS(
		SELECT EmployeeID,Count(*)  TotalOrders
		From Orders
		Where RequiredDate <=ShippedDate
		Group By EmployeeID),
		AllOrders AS(
		SELECT EmployeeID,Count(*)  TotalOrders
		From Orders Group By
		EmployeeID)
		SELECT Employees.EmployeeID,LastName,
		AllOrders.TotalOrders "AllOrders",
		ISNULL(LateOrders.TotalOrders, 0) "LateOrders "
		FROM Employees Join AllOrders 
		ON AllOrders.EmployeeID = Employees.EmployeeID
		Left Join LateOrders
		ON LateOrders.EmployeeID = Employees.EmployeeID

-- 46. Late orders vs. total orders - percentage
		WITH LateOrders AS(
		SELECT EmployeeID,Count(*)  TotalOrders
		From Orders
		Where RequiredDate <=ShippedDate
		Group By EmployeeID),
		AllOrders AS(
		SELECT EmployeeID,Count(*)  TotalOrders
		From Orders Group By
		EmployeeID)
		SELECT Employees.EmployeeID ,LastName,
		AllOrders.TotalOrders  "AllOrders",
		IsNull(LateOrders.TotalOrders, 0) "LateOrders",
		(IsNull(LateOrders.TotalOrders, 0) * 1.00) / AllOrders.TotalOrders "PercentLateOrders"
		FROM Employees Join AllOrders 
		ON AllOrders.EmployeeID = Employees.EmployeeID
		Left Join LateOrders
		ON LateOrders.EmployeeID = Employees.EmployeeID

-- 47. Late orders vs. total orders - fix decimal
		WITH LateOrders AS(
		SELECT EmployeeID,Count(*)  TotalOrders
		From Orders
		Where RequiredDate <=ShippedDate
		Group By EmployeeID),
		AllOrders AS(
		SELECT EmployeeID,Count(*)  TotalOrders
		From Orders Group By
		EmployeeID)
		SELECT Employees.EmployeeID ,LastName,
		AllOrders.TotalOrders  "AllOrders",
		IsNull(LateOrders.TotalOrders, 0) "LateOrders",
		Convert(Decimal (10,2) ,(IsNull(LateOrders.TotalOrders, 0) * 1.00)
		/AllOrders.TotalOrders ) "PercentLateOrders"
		FROM Employees Join AllOrders 
		ON AllOrders.EmployeeID = Employees.EmployeeID
		Left Join LateOrders
		ON LateOrders.EmployeeID = Employees.EmployeeID

-- 48. Customer grouping (NO OUTPUT)
		WITH Orders2016 AS(
		SELECT Customers.CustomerID, Customers.CompanyName,
		SUM(Quantity *UnitPrice) "TotalOrderAmount"
		FROM Customers Join Orders 
		ON Orders.CustomerID = Customers.CustomerID
		Join [Order Details]
		ON Orders.OrderID = [Order Details].OrderID
		WHERE OrderDate >= '20160101'
		AND OrderDate < '20170101'
		GROUP BY Customers.CustomerID, Customers.CompanyName)
		SELECT CustomerID, CompanyName ,TotalOrderAmount,
		CustomerGroup =
		Case when TotalOrderAmount between 0 and 1000 then 'Low'
		when TotalOrderAmount between 1001 and 5000 then 'Medium'
		when TotalOrderAmount between 5001 and 10000 then 'High'
		when TotalOrderAmount > 10000 then 'Very High'
		End 
		FROM Orders2016
		ORDER BY CustomerID

-- 50. Customer grouping with percentage (NO OUTPUT)
		WITH Orders2016 AS(
		SELECT Customers.CustomerID, Customers.CompanyName,
		SUM(Quantity *UnitPrice) "TotalOrderAmount"
		FROM Customers Join Orders 
		ON Orders.CustomerID = Customers.CustomerID
		Join [Order Details]
		ON Orders.OrderID = [Order Details].OrderID
		WHERE OrderDate >= '20160101'
		AND OrderDate < '20170101'
		GROUP BY Customers.CustomerID, Customers.CompanyName),
		CustomerGrouping AS (
		SELECT CustomerID, CompanyName ,TotalOrderAmount,
		CustomerGroup =
		Case when TotalOrderAmount between 0 and 1000 then 'Low'
		when TotalOrderAmount between 1001 and 5000 then 'Medium'
		when TotalOrderAmount between 5001 and 10000 then 'High'
		when TotalOrderAmount > 10000 then 'Very High'
		End 
		FROM Orders2016)
		Select CustomerGroup ,Count(*) "TotalInGroup", 
		Count(*) * 1.0/ (select count(*) from CustomerGrouping) "PercentageInGroup"
		FROM CustomerGrouping 
		GROUP BY CustomerGroup 
		ORDER BY TotalInGroup desc

-- 52. Countries with suppliers or customers
		SELECT Country FROM Customers
		Union
		SELECT Country FROM Suppliers
		ORDER BY Country

-- 53. Countries with suppliers or customers, version 2
		With SupplierCountries AS(
		SELECT DISTINCT Country 
		FROM Suppliers),
		CustomerCountries AS(
		(SELECT DISTINCT Country FROM Customers))
		SELECT
		SupplierCountries .Country "SupplierCountry",
		CustomerCountries .Country "CustomerCountry "
		FROM SupplierCountries
		Full Outer Join CustomerCountries
		ON CustomerCountries.Country = SupplierCountries.Country

-- 54. Countries with suppliers or customers - version 3
		WITH SupplierCountries AS(
		SELECT Country , Count(*)  Total
		FROM Suppliers
		GROUP BY Country)
		,CustomerCountries AS(
		SELECT Country , Count(*) Total
		FROM Customers
		GROUP BY Country)
		SELECT 
		isnull(SupplierCountries.Country, CustomerCountries.Country) " Country",
		isnull(SupplierCountries.Total,0) "TotalSuppliers",
		isnull(CustomerCountries.Total,0) TotalCustomers
		FROM SupplierCountries Full Outer Join CustomerCountries
		ON CustomerCountries.Country = SupplierCountries.Country

-- 55.First order in each country
		WITH OrdersByCountry AS(
		SELECT ShipCountry, CustomerID, OrderID,
		convert(date, OrderDate) OrderDate,
		Row_Number() over (Partition by ShipCountry Order by ShipCountry, OrderID) RowNumberPerCountry
		FROM Orders)
		SELECT ShipCountry, CustomerID, OrderID, OrderDate
		FROM OrdersByCountry
		WHERE RowNumberPerCountry = 1
		ORDER BY ShipCountry

-- 56. Customers with multiple orders in 5 day period
		SELECT I.CustomerID, I.OrderID "InitialOrderID",
		convert(date, I.OrderDate) InitialOrderDate,
		N.OrderID "NextOrderID" , convert(date, N.OrderDate) "NextOrderDate",
		datediff(dd, I.OrderDate, N.OrderDate)  "DaysBetween"
		FROM Orders I join Orders N
		ON I.CustomerID = N.CustomerID
		WHERE I.OrderID < N.OrderID
		AND datediff(dd, I.OrderDate, N.OrderDate) <= 5
		ORDER BY I.CustomerID,I.OrderID


-- 57. Customers with multiple orders in 5 day period, version 2
		With NextOrderDate as (
		Select CustomerID , convert(date, OrderDate) "OrderDate",
		Convert(date ,Lead(OrderDate,1) OVER (Partition by CustomerID order by CustomerID, OrderDate))  "NextOrderDate"
		FROM Orders )
		SELECT CustomerID ,OrderDate ,NextOrderDate ,
		DateDiff (dd, OrderDate,NextOrderDate) "DaysBetweenOrders "
		FROM NextOrderDate
		WHERE DateDiff (dd, OrderDate,NextOrderDate) <= 5
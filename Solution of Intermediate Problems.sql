-- 20. Categories, and the total products in each category
		SELECT Categoryname, count(CategoryName) TotalProducts
		FROM Categories C, Products P
		WHERE C.CategoryID = P.CategoryID
		GROUP BY CategoryName
		ORDER BY count(P.categoryid) DESC

-- 21. Total customers per country/city
		SELECT  Country, City , COUNT(customerid) "TOTAL NUMBER"
		FROM Customers
		GROUP BY Country, City

-- 22. Products that need reordering
		SELECT ProductID, ProductName, UnitsInStock, ReorderLevel
		FROM Products
		WHERE UnitsInStock < ReorderLevel
		ORDER BY ProductID

-- 23. Products that need reordering, continued
		Select ProductID ,ProductName, UnitsInStock, UnitsOnOrder,
		ReorderLevel, Discontinued
		FROM Products
		WHERE UnitsInStock + UnitsOnOrder <= ReorderLevel
		AND Discontinued = 0
		ORDER BY ProductID

-- 24. Customer list by region
		SELECT CustomerID ,CompanyName ,Region,
		RegionOrder=
		Case
		when Region is null then 1
		else 0
		End
		From Customers
		Order By RegionOrder, Region,CustomerID

-- 25. High freight charges
		SELECT TOP(3) ShipCountry, AVG(Freight)
		FROM Orders
		GROUP BY ShipCountry
		ORDER BY  AVG(Freight) DESC

-- 26. High freight charges - 2015
		SELECT TOP(3) ShipCountry, AVG(Freight) "AverageFreight"
		FROM Orders
		WHERE YEAR(OrderDate) = 2015
		GROUP BY ShipCountry
		ORDER BY AVG(Freight) DESC


-- 28. High freight charges - last year
		SELECT TOP(3) ShipCountry, AVG(Freight) "AverageFreight"
		FROM Orders
		WHERE OrderDate >= Dateadd(yy, -1, (Select max(OrderDate) from Orders))
		Group by ShipCountry
		Order by AverageFreight desc

-- 29. Inventory list
		SELECT OO.EmployeeID, LastName, OO.OrderID, ProductName, Quantity
		FROM Employees E,[Order Details] O,Products P ,Orders OO
		WHERE P.ProductID= O.ProductID
		AND O.OrderID = OO.OrderID
		AND E.EmployeeID = OO.EmployeeID
		ORDER BY OrderID, O.ProductID

-- 30. Customers with no orders
		SELECT C.CustomerID "Customer ID", O.CustomerID "Order Cusromer ID"
		FROM Customers C left join Orders O
		ON O.CustomerID = C.CustomerID
		WHERE O.CustomerID IS NULL

-- 31. Customers with no orders for EmployeeID 4 
		SELECT C.CustomerID "Customer ID", O.CustomerID "Order Cusromer ID"
		FROM Customers C left join Orders O
		ON O.CustomerID = C.CustomerID AND EmployeeID =4
		WHERE O.CustomerID IS NULL
		

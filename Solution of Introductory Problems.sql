-- 1. Which shippers do we have?
		SELECT *
		FROM Shippers

-- 2. In the Categories table, selecting CategoryName and Description.
		SELECT CategoryName, Description
		FROM Categories

--3. We’d like to see just the FirstName, LastName, and HireDate
--   of all the employees with the Title of Sales Representative.
		SELECT FirstName, LastName,HireDate
		FROM Employees
		WHERE Title = 'Sales Representative'

-- 4. Sales Representatives in the United States
		SELECT FirstName, LastName,HireDate
		FROM Employees
		WHERE Title = 'Sales Representative'
		AND Country = 'USA'

-- 5. Show all the orders placed by a specific employee.
--    The EmployeeID for this Employee (Steven Buchanan) is 5.
		SELECT * 
		FROM Orders
		WHERE EmployeeID = 5

-- 6. In the Suppliers table, show the SupplierID,
--    ContactName, and ContactTitle for those Suppliers
--    whose ContactTitle is not Marketing Manager.
		SELECT SupplierID, ContactName, ContactTitle
		FROM Suppliers
		WHERE ContactTitle != 'Marketing Manager'

-- 7. In the products table, we’d like to see the ProductID and
--    ProductName for those products where the ProductName
--    includes the string “queso”.
		SELECT ProductID, ProductName
		FROM Products
		WHERE ProductName LIKE '%queso%'

-- 8. Looking at the Orders table, there’s a field called
--    ShipCountry. Write a query that shows the OrderID,
--    CustomerID, and ShipCountry for the orders where the
--    ShipCountry is either France or Belgium.
		SELECT OrderID, CustomerID,  ShipCountry
		FROM Orders
		WHERE ShipCountry = 'France' OR ShipCountry = 'Belgium'

-- 9. Orders shipping to any country in Latin America
		SELECT OrderID, CustomerID,  ShipCountry
		FROM Orders
		WHERE ShipCountry IN ('Brazil', 'Mexico', 'Argentina', 'Venezuela')

-- 10. For all the employees in the Employees table, show the
--     FirstName, LastName, Title, and BirthDate. Order the
--     results by BirthDate, so we have the oldest employees first.
		SELECT FirstName, LastName, Title, BirthDate
		FROM Employees
		ORDER BY BirthDate

-- 11. Showing only the Date with a DateTime field
		SELECT FirstName, LastName, Title,CONVERT(DATE, BirthDate) "Bdate"
		FROM Employees
		ORDER BY BirthDate

-- 12. Employees full name
		SELECT  FirstName, LastName,
		CONCAT (FirstName,' ', LastName) "Full Name"
		FROM Employees

-- 13. OrderDetails amount per line item
		SELECT OrderID, ProductID, UnitPrice,Quantity,
		UnitPrice * Quantity "TotalPrice"
		FROM [Order Details]
		ORDER BY OrderID , ProductID

-- 14. How many customers?
		SELECT COUNT(CustomerID)
		FROM Customers

-- 15. When was the first order?
		SELECT MIN(OrderDate) "First order"
		FROM Orders

-- 16. Countries where there are customers
		SELECT DISTINCT COUNTRY
		FROM Customers

-- 17. Show a list of all the different values in the Customers
--     table for ContactTitles. Also include a count for each ContactTitle.
		SELECT ContactTitle, COUNT(ContactTitle)
		FROM Customers
		GROUP BY ContactTitle

-- 18. Products with associated supplier names
		SELECT ProductID, ProductName,CompanyName
		FROM Products P, Suppliers S
		WHERE P.SupplierID = S.SupplierID
		ORDER BY ProductID
		
-- 19. Orders and the Shipper that was used
		SELECT OrderID, CONVERT(DATE,OrderDate), CompanyName
		FROM Orders, Shippers
		WHERE ShipVia = ShipperID
		AND OrderID < 10300
		ORDER BY OrderID
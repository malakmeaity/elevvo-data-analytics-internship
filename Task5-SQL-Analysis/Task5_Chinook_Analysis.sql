/* =====================================================================
   Task 5: SQL-Based Analysis of Product Sales
   Dataset : Chinook Database (SQLite)
   Tool    : DB Browser for SQLite
   Tables  : Invoice, InvoiceLine, Track, Album, Artist, Genre
   Run each query on its own (select it, then press Ctrl+Enter).
   ===================================================================== */

-- Q1: Top 10 best-selling tracks (JOIN: InvoiceLine, Track, Album, Artist)
SELECT t.Name AS Track, ar.Name AS Artist,
       SUM(il.Quantity) AS UnitsSold,
       ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS Revenue
FROM InvoiceLine il
JOIN Track t   ON il.TrackId = t.TrackId
JOIN Album al  ON t.AlbumId = al.AlbumId
JOIN Artist ar ON al.ArtistId = ar.ArtistId
GROUP BY t.TrackId
ORDER BY UnitsSold DESC, Revenue DESC, Track
LIMIT 10;

-- Q2: Top 10 artists by revenue
SELECT ar.Name AS Artist,
       SUM(il.Quantity) AS UnitsSold,
       ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS Revenue
FROM InvoiceLine il
JOIN Track t   ON il.TrackId = t.TrackId
JOIN Album al  ON t.AlbumId = al.AlbumId
JOIN Artist ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.ArtistId
ORDER BY Revenue DESC
LIMIT 10;

-- Q3: Revenue by genre
SELECT g.Name AS Genre,
       SUM(il.Quantity) AS UnitsSold,
       ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS Revenue
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.GenreId
ORDER BY Revenue DESC;

-- Q4: Revenue per region (country)
SELECT BillingCountry AS Country,
       COUNT(InvoiceId) AS Orders,
       ROUND(SUM(Total), 2) AS Revenue,
       ROUND(100.0 * SUM(Total) / (SELECT SUM(Total) FROM Invoice), 1) AS PctOfTotal
FROM Invoice
GROUP BY BillingCountry
ORDER BY Revenue DESC;

-- Q5: Monthly performance
SELECT strftime('%Y-%m', InvoiceDate) AS Month,
       COUNT(InvoiceId) AS Orders,
       ROUND(SUM(Total), 2) AS Revenue
FROM Invoice
GROUP BY Month
ORDER BY Month;

-- Q6: Yearly performance
SELECT strftime('%Y', InvoiceDate) AS Year,
       COUNT(InvoiceId) AS Orders,
       ROUND(SUM(Total), 2) AS Revenue
FROM Invoice
GROUP BY Year
ORDER BY Year;

-- Bonus A: Rank artists by revenue (RANK window function)
SELECT RANK() OVER (ORDER BY Revenue DESC) AS Rank, Artist, Revenue
FROM (
  SELECT ar.Name AS Artist,
         ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS Revenue
  FROM InvoiceLine il
  JOIN Track t   ON il.TrackId = t.TrackId
  JOIN Album al  ON t.AlbumId = al.AlbumId
  JOIN Artist ar ON al.ArtistId = ar.ArtistId
  GROUP BY ar.ArtistId
)
LIMIT 10;

-- Bonus B: Top-selling artist in each country (ROW_NUMBER with PARTITION BY)
SELECT Country, Artist, Revenue
FROM (
  SELECT i.BillingCountry AS Country, ar.Name AS Artist,
         ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS Revenue,
         ROW_NUMBER() OVER (PARTITION BY i.BillingCountry
                            ORDER BY SUM(il.UnitPrice * il.Quantity) DESC) AS rn
  FROM Invoice i
  JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
  JOIN Track t   ON il.TrackId = t.TrackId
  JOIN Album al  ON t.AlbumId = al.AlbumId
  JOIN Artist ar ON al.ArtistId = ar.ArtistId
  GROUP BY i.BillingCountry, ar.ArtistId
)
WHERE rn = 1
ORDER BY Revenue DESC
LIMIT 10;

-- Bonus C: Monthly revenue with previous month and % change (LAG window function)
SELECT Month, Revenue,
       LAG(Revenue) OVER (ORDER BY Month) AS PrevMonth,
       ROUND(100.0 * (Revenue - LAG(Revenue) OVER (ORDER BY Month))
             / LAG(Revenue) OVER (ORDER BY Month), 1) AS PctChange
FROM (
  SELECT strftime('%Y-%m', InvoiceDate) AS Month,
         ROUND(SUM(Total), 2) AS Revenue
  FROM Invoice
  GROUP BY Month
)
ORDER BY Month
LIMIT 12;

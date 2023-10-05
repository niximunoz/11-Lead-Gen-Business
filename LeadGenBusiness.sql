/*1. ¿Qué consulta ejecutaría para obtener los ingresos totales para marzo de 2012?*/

SELECT monthname(charged_datetime) AS month, SUM(amount) AS totales 
FROM billing
WHERE date(charged_datetime) BETWEEN '2012-03-01' AND '2012-03-30';

/*2. ¿Qué consulta ejecutaría para obtener los ingresos totales recaudados del cliente con una identificación de 2?*/

SELECT client_id, SUM(amount) 
FROM billing
WHERE client_id = 2;

/*3. ¿Qué consulta ejecutaría para obtener todos los sitios que posee client = 10?*/

SELECT domain_name, client_id FROM sites
WHERE client_id = 10;

/*4. ¿Qué consulta ejecutaría para obtener el número total de sitios creados por mes por año para el cliente con una identificación de 1? 
¿Qué pasa con el cliente = 20?*/

SELECT client_id,
	COUNT(domain_name) AS number_of_websites, 
    monthname(created_datetime) AS month_created , 
    YEAR(created_datetime) AS year_created 
FROM sites
WHERE client_id = 1
GROUP BY created_datetime;

/*5. ¿Qué consulta ejecutaría para obtener el número total de clientes potenciales generados para cada uno de los sitios entre el 1 de enero de 2011 y el 15 de febrero de 2011?*/

SELECT sites.domain_name, count(leads.leads_id), DATE_FORMAT(leads.registered_datetime, '%M %d, %Y') AS date_generated
FROM sites
JOIN leads ON sites.site_id = leads.site_id
WHERE DATE(leads.registered_datetime) BETWEEN '2011-01-01' AND '2011-02-15'
GROUP BY sites.domain_name;

/*6. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales 
que hemos generado para cada uno de nuestros clientes entre el 1 de enero de 2011 y el 31 de diciembre de 2011?*/

SELECT CONCAT(clients.first_name , ' ', clients.last_name) AS client_name,
	COUNT(leads.leads_id) AS number_of_leads
FROM clients
JOIN sites ON clients.client_id = sites.client_id
JOIN leads ON sites.site_id = leads.site_id
WHERE DATE(leads.registered_datetime) BETWEEN '2011-01-01' AND '2011-12-31'
GROUP BY clients.client_id;

/*7. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales que hemos generado para cada cliente 
cada mes entre los meses 1 y 6 del año 2011?*/

SELECT CONCAT(clients.first_name , ' ', clients.last_name) AS client_name,
	COUNT(leads.leads_id) AS number_of_leads,
    DATE_FORMAT(leads.registered_datetime, '%M') AS month_generated
FROM clients
JOIN sites ON clients.client_id = sites.client_id
JOIN leads ON sites.site_id = leads.site_id
WHERE month(leads.registered_datetime) BETWEEN 1 AND 6
GROUP BY clients.client_id;


/*8. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales que hemos generado para cada uno de los 
sitios de nuestros clientes entre el 1 de enero de 2011 y el 31 de diciembre de 2011? Solicite esta consulta por ID de cliente. 
Presente una segunda consulta que muestre todos los clientes, los nombres del sitio y el número total de clientes potenciales generados en cada sitio en todo momento.*/

SELECT CONCAT(clients.first_name , ' ', clients.last_name) AS client_name,
	sites.domain_name,
    COUNT(leads.leads_id) AS number_of_leads,
    DATE_FORMAT(leads.registered_datetime, '%M %d, %Y') AS month_generated
FROM clients
JOIN sites ON clients.client_id = sites.client_id
JOIN leads ON sites.site_id = leads.site_id
WHERE year(leads.registered_datetime) = 2011
GROUP BY sites.domain_name
ORDER BY clients.client_id;

SELECT CONCAT(clients.first_name , ' ', clients.last_name) AS client_name,
	sites.domain_name,
    COUNT(leads.leads_id) AS number_of_leads
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
LEFT JOIN leads ON sites.site_id = leads.site_id
GROUP BY sites.domain_name
ORDER BY clients.client_id;

/*9. Escriba una sola consulta que recupere los ingresos totales recaudados de cada cliente para cada mes del año. Pídalo por ID de cliente.*/

SELECT CONCAT(clients.first_name , ' ', clients.last_name) AS client_name,
		SUM(billing.amount) as total_revenue,
        MONTHNAME(billing.charged_datetime) AS month_charge,
        DATE_FORMAT(billing.charged_datetime, '%Y') AS date_generated
FROM clients
JOIN billing ON clients.client_id = billing.client_id
GROUP BY billing.billing_id
ORDER BY billing.client_id;

/*10. Escriba una sola consulta que recupere todos los sitios que posee cada cliente. Agrupe los resultados para que cada fila muestre un nuevo cliente. 
Se volverá más claro cuando agregue un nuevo campo llamado 'sitios' que tiene todos los sitios que posee el cliente. (SUGERENCIA: use GROUP_CONCAT)*/

SELECT CONCAT(clients.first_name , ' ', clients.last_name) AS client_name,
	GROUP_CONCAT( domain_name SEPARATOR ' / ') AS sites
 FROM clients
JOIN sites ON clients.client_id = sites.client_id
GROUP BY clients.client_id
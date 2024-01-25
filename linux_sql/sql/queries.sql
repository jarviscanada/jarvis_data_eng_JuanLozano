-- Query to retrieve number of hosts
SELECT COUNT(*) AS total_hosts FROM host_info;

-- Query to calculate the average disk space available on all hosts
SELECT AVG(disk_available) AS avg_disk_available
FROM host_usage;

-- Query to report the host's total memory and its average memory free
SELECT hi.hostname, hi.total_mem, AVG(hu.memory_free) AS avg_memory_free
FROM host_info hi
JOIN host_usage hu ON hi.id = hu.host_id
GROUP BY hi.hostname, hi.total_mem;

-- Query to find the number of times disk I/O is occurring on average
SELECT hostname, AVG(disk_io) AS avg_disk_io
FROM host_info hi
JOIN host_usage hu ON hi.id = hu.host_id
GROUP BY hostname;

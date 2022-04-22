SELECT
    lead(cpu_number, 0) OVER (
        PARTITION BY cpu_number
        ORDER BY total_mem DESC
    ) AS cpu_number,
    id AS host_id,
    total_mem
FROM host_info;

SELECT
    host_id,
    hostname,
    timestamp,
    avg_used_mem_percentage
FROM
    (SELECT
        host_id,
        hostname,
        date_trunc('hour', host_usage.timestamp) + INTERVAL '5 min' * ROUND(date_part('minute', host_usage.timestamp) / 5.0) AS timestamp,
        AVG(((total_mem-(memory_free*1024))/total_mem::float)*100) OVER (
            PARTITION BY host_id, date_trunc('hour', host_usage.timestamp) + INTERVAL '5 min' * ROUND(date_part('minute', host_usage.timestamp) / 5.0)
        ) AS avg_used_mem_percentage
    FROM host_info, host_usage WHERE host_info.id = host_usage.host_id) sub
GROUP BY avg_used_mem_percentage, host_id, hostname, timestamp
ORDER BY host_id, timestamp
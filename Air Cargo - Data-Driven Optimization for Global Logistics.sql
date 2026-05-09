SELECT COUNT(*) FROM air_cargo_operations;
USE air_cargo_analytics;
SELECT 
    SUM(CASE WHEN record_id IS NULL THEN 1 ELSE 0 END) AS null_record_id,
    SUM(CASE WHEN flight_delay IS NULL THEN 1 ELSE 0 END) AS null_flight_delay,
    SUM(CASE WHEN handling_time IS NULL THEN 1 ELSE 0 END) AS null_handling_time,
    SUM(CASE WHEN waiting_time IS NULL THEN 1 ELSE 0 END) AS null_waiting_time,
    SUM(CASE WHEN allocation_strategy IS NULL THEN 1 ELSE 0 END) AS null_strategy,
    SUM(CASE WHEN weather_condition IS NULL THEN 1 ELSE 0 END) AS null_weather,
    SUM(CASE WHEN bottleneck_flag IS NULL THEN 1 ELSE 0 END) AS null_bottleneck,
    COUNT(*) AS total_rows
FROM air_cargo_operations;

SELECT record_id, COUNT(*) 
FROM air_cargo_operations 
GROUP BY record_id 
HAVING COUNT(*) > 1;

SELECT flight_id, timestamp, COUNT(*) 
FROM air_cargo_operations 
GROUP BY flight_id, timestamp 
HAVING COUNT(*) > 1;

SELECT 
    'flight_delay' AS column_name,
    MIN(flight_delay) AS min_value,
    MAX(flight_delay) AS max_value,
    ROUND(AVG(flight_delay), 2) AS avg_value,
    ROUND(STDDEV(flight_delay), 2) AS std_dev
FROM air_cargo_operations
UNION ALL
SELECT 
    'handling_time',
    MIN(handling_time),
    MAX(handling_time),
    ROUND(AVG(handling_time), 2),
    ROUND(STDDEV(handling_time), 2)
FROM air_cargo_operations
UNION ALL
SELECT 
    'waiting_time',
    MIN(waiting_time),
    MAX(waiting_time),
    ROUND(AVG(waiting_time), 2),
    ROUND(STDDEV(waiting_time), 2)
FROM air_cargo_operations
UNION ALL
SELECT 
    'operational_cost',
    MIN(operational_cost),
    MAX(operational_cost),
    ROUND(AVG(operational_cost), 2),
    ROUND(STDDEV(operational_cost), 2)
FROM air_cargo_operations
UNION ALL
SELECT 
    'throughput_rate',
    MIN(throughput_rate),
    MAX(throughput_rate),
    ROUND(AVG(throughput_rate), 2),
    ROUND(STDDEV(throughput_rate), 2)
FROM air_cargo_operations;

SELECT DISTINCT cargo_type FROM air_cargo_operations;
SELECT DISTINCT shipment_priority FROM air_cargo_operations;
SELECT DISTINCT arrival_departure FROM air_cargo_operations;
SELECT DISTINCT weather_condition FROM air_cargo_operations;
SELECT DISTINCT allocation_strategy FROM air_cargo_operations;
SELECT DISTINCT allocation_efficiency_class FROM air_cargo_operations;
SELECT DISTINCT equipment_type FROM air_cargo_operations;

SELECT COUNT(*) AS anomaly_bottleneck_no_delay
FROM air_cargo_operations 
WHERE bottleneck_flag = 1 AND flight_delay < 5;

SELECT COUNT(*) AS negative_values
FROM air_cargo_operations 
WHERE flight_delay < 0 
   OR handling_time < 0 
   OR waiting_time < 0
   OR operational_cost < 0;
   
SELECT COUNT(*) FROM air_cargo_operations 
WHERE bottleneck_flag = 1 AND flight_delay < 5;

SELECT 
    shipment_priority,
    weather_condition,
    peak_hour_indicator,
    ROUND(AVG(flight_delay), 2) AS avg_delay_minutes,
    COUNT(*) AS total_shipments,
    ROUND(SUM(CASE WHEN flight_delay > 30 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_delay_gt30
FROM air_cargo_operations
GROUP BY shipment_priority, weather_condition, peak_hour_indicator
ORDER BY avg_delay_minutes DESC
LIMIT 10;

SELECT 
    allocation_strategy,
    ROUND(AVG(flight_delay), 2) AS avg_delay_min,
    ROUND(AVG(handling_time + waiting_time), 2) AS avg_total_processing_min,
    ROUND(AVG(throughput_rate), 2) AS avg_throughput_tons_per_hour,
    ROUND(AVG(operational_cost), 2) AS avg_cost_per_shipment,
    ROUND(AVG(bottleneck_flag) * 100, 2) AS pct_bottleneck,
    COUNT(*) AS total_shipments
FROM air_cargo_operations
GROUP BY allocation_strategy
ORDER BY avg_delay_min ASC, avg_throughput_tons_per_hour DESC;

SELECT 
    terminal_id,
    COUNT(*) AS total_operations,
    ROUND(SUM(bottleneck_flag) * 100.0 / COUNT(*), 2) AS bottleneck_percentage,
    ROUND(AVG(queue_length), 2) AS avg_queue_length,
    ROUND(AVG(facility_utilization), 2) AS avg_utilization_pct,
    ROUND(AVG(workforce_assigned), 2) AS avg_workforce,
    ROUND(AVG(equipment_used), 2) AS avg_equipment
FROM air_cargo_operations
GROUP BY terminal_id
ORDER BY bottleneck_percentage DESC
LIMIT 5;

SELECT 
    CASE WHEN peak_hour_indicator = 1 THEN 'Peak Hour' ELSE 'Off-Peak' END AS time_period,
    ROUND(AVG(flight_delay), 2) AS avg_delay_min,
    ROUND(AVG(throughput_rate), 2) AS avg_throughput,
    ROUND(AVG(operational_cost), 2) AS avg_cost,
    ROUND(AVG(queue_length), 2) AS avg_queue,
    ROUND(AVG(bottleneck_flag) * 100, 2) AS pct_bottleneck,
    ROUND(AVG(workforce_assigned), 2) AS avg_workforce,
    ROUND(AVG(equipment_used), 2) AS avg_equipment
FROM air_cargo_operations
GROUP BY peak_hour_indicator;

SELECT 
    allocation_efficiency_class,
    ROUND(SUM(CASE WHEN allocation_strategy = 'Adaptive' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_using_adaptive,
    ROUND(AVG(workforce_assigned), 2) AS avg_workforce,
    ROUND(AVG(equipment_used), 2) AS avg_equipment,
    ROUND(AVG(throughput_rate), 2) AS avg_throughput,
    ROUND(AVG(operational_cost), 2) AS avg_cost,
    ROUND(AVG(flight_delay), 2) AS avg_delay,
    COUNT(*) AS total_shipments
FROM air_cargo_operations
GROUP BY allocation_efficiency_class
ORDER BY allocation_efficiency_class DESC;


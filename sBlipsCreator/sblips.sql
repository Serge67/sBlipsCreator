CREATE TABLE `sblips` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `sprite` int(3) DEFAULT NULL,
  `display` int(2) DEFAULT NULL,
  `scale` float DEFAULT NULL,
  `color` int(3) DEFAULT NULL,
  `flashes` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `sblips`
  ADD PRIMARY KEY (`name`);
COMMIT;
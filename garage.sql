ALTER TABLE `owned_vehicles` ADD `impound` tinyint(1) NOT NULL DEFAULT 0;
ALTER TABLE `owned_vehicles` ADD `park` tinyint(1) NOT NULL DEFAULT 0;
ALTER TABLE `owned_vehicles` ADD `engine_health` float DEFAULT 999.999;
ALTER TABLE `owned_vehicles` ADD `body_health` float DEFAULT 999.999;
ALTER TABLE `owned_vehicles` ADD `deformation` longtext;
ALTER TABLE `owned_vehicles` ADD `fuel_level` float DEFAULT 99.99;
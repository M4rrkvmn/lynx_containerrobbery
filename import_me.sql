CREATE TABLE IF NOT EXISTS `lynx_containerrobbery` (
    PRIMARY KEY (`id`),
    `identifier` varchar(255) NOT NULL,
    `name` varchar(255) NOT NULL,
    `count` int(11) NOT NULL,
    `difficulty` varchar(255) NOT NULL,
    `xp` int(11) NOT NULL,
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
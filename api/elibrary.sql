-- phpMyAdmin SQL Dump
-- version 4.4.15.10
-- https://www.phpmyadmin.net
--
-- 主機: localhost
-- 產生時間： 2023 年 08 月 11 日 08:13
-- 伺服器版本: 5.5.68-MariaDB
-- PHP 版本： 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `elibrary`
--

-- --------------------------------------------------------

--
-- 資料表結構 `books`
--

CREATE TABLE IF NOT EXISTS `books` (
  `book_id` int(6) unsigned NOT NULL,
  `title` varchar(50) NOT NULL,
  `authors` varchar(50) NOT NULL,
  `publishers` varchar(50) NOT NULL,
  `date` varchar(50) NOT NULL,
  `isbn` varchar(50) NOT NULL,
  `status` int(6) NOT NULL DEFAULT '0',
  `borrowed_by` int(6) DEFAULT '-1',
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `books`
--

INSERT INTO `books` (`book_id`, `title`, `authors`, `publishers`, `date`, `isbn`, `status`, `borrowed_by`, `last_updated`) VALUES
(1, 'Harry Potter', 'J. K. R.', 'ABC Company', '1995-09-01', '123-4-56789-10', 1, 5, '2023-08-08 13:15:45'),
(2, 'Harry Potter 2', 'J. K. R.', 'ABC Company', '1996-05-01', '123-4-56789-11', 1, 5, '2023-08-09 03:58:42'),
(3, 'Harry Potter 3', 'J. K. R.', 'ABC Company', '1997-05-01', '123-4-56789-12', 0, -1, '2023-08-08 11:17:50'),
(4, 'Harry Potter 4', 'J. K. R.', 'ABC Company', '1999-02-01', '123-4-56789-13', 0, -1, '2023-08-09 04:06:09'),
(5, 'Harry Potter 5', 'J. K. R.', 'ABC Company', '2000-08-01', '123-4-56789-14', 0, -1, '2023-08-08 11:17:58'),
(6, 'Harry Potter 6', 'J. K. R.', 'ABC Company', '2002-03-01', '123-4-56789-15', 0, -1, '2023-08-08 11:18:02'),
(7, 'Harry Potter 7', 'J. K. R.', 'ABC Company', '2003-04-01', '123-4-56789-16', 0, -1, '2023-08-09 03:58:48'),
(8, 'book1', 'au1', 'pu1', '1234-05-06', '1234-5-1111-1', 0, -1, '2023-08-08 11:18:08'),
(9, 'book2', 'au1', 'pu1', '1234-05-06', '1234-5-1111-2', 0, -1, '2023-08-08 11:18:12'),
(10, 'book3', 'au1', 'pu1', '1234-05-06', '1234-5-1111-3', 0, -1, '2023-08-08 11:18:15');

-- --------------------------------------------------------

--
-- 資料表結構 `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int(6) unsigned NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `is_admin` int(6) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `is_admin`) VALUES
(1, 'chantaiman', '12345678', 0),
(2, 'leesiuming', '12345678', 0),
(3, 'admin', 'admin', 1),
(4, 'user1', 'abcd1234', 0),
(5, 'user2', 'e19d5cd5af0378da05f63f891c7467af', 0),
(6, 'admin2', '21232f297a57a5a743894a0e4a801fc3', 1),
(9, 'user3', 'e19d5cd5af0378da05f63f891c7467af', 0);

--
-- 已匯出資料表的索引
--

--
-- 資料表索引 `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`book_id`),
  ADD UNIQUE KEY `book_id` (`book_id`),
  ADD UNIQUE KEY `title` (`title`),
  ADD UNIQUE KEY `isbn` (`isbn`);

--
-- 資料表索引 `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- 在匯出的資料表使用 AUTO_INCREMENT
--

--
-- 使用資料表 AUTO_INCREMENT `books`
--
ALTER TABLE `books`
  MODIFY `book_id` int(6) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=11;
--
-- 使用資料表 AUTO_INCREMENT `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(6) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=10;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

--liquibase formatted sql

--changeset smallsnail-wh:20190715-1

CREATE TABLE `notice` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `form` tinyint(1) DEFAULT NULL COMMENT '公告类型（0：普通公告，1：图文）',
  `image` varchar(255) DEFAULT NULL COMMENT '图片url',
  `content` text NOT NULL COMMENT '内容',
  `url` varchar(255) DEFAULT NULL COMMENT '公告链接',
  `del` tinyint(1) DEFAULT '0' COMMENT '逻辑删除（0:启用，1:删除）',
  `create_time` varchar(255) DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(255) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公告表'

--changeset smallsnail-wh:20190715-2

INSERT INTO `sys_menu` (`id`, `name`, `parent_id`, `sort`, `icon`) VALUES ('17', '日志管理', '0', '6', 'el-icon-info');
INSERT INTO `sys_menu` (`id`, `name`, `url`, `parent_id`, `sort`, `icon`) VALUES ('18', '错误日志', '/base/log', '17', '1', 'el-icon-warning');
INSERT INTO `interest_test`.`sys_menu` (`id`, `name`, `parent_id`, `sort`, `icon`) VALUES ('19', '公告管理', '0', '6', 'el-icon-message-solid');
INSERT INTO `interest_test`.`sys_menu` (`id`, `name`, `url`, `parent_id`, `sort`, `icon`) VALUES ('20', '公告', '/base/notice', '19', '1', 'el-icon-bell');

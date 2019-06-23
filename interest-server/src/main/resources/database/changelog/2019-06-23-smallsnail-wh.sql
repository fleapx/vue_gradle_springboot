--liquibase formatted sql

--changeset smallsnail-wh:20190623-1
CREATE TABLE `article` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `title` varchar(255) NOT NULL COMMENT '标题',
  `info` text NOT NULL COMMENT '简介',
  `content` longtext NOT NULL COMMENT '内容',
  `click_rate` int(11) DEFAULT '0' COMMENT '点击量',
  `comment_count` int(11) DEFAULT '0' COMMENT '评论量',
  `top` int(1) DEFAULT '0' COMMENT '置顶（0:不置顶，1:置顶）',
  `create_time` varchar(255) DEFAULT NULL COMMENT '创建时间',
  `reply_time` varchar(255) DEFAULT NULL COMMENT '最新回复时间',
  `userid` int(11) NOT NULL COMMENT '创建人id',
  `del` tinyint(1) DEFAULT '0' COMMENT '逻辑删除（0:启用，1:删除）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章表';

--changeset smallsnail-wh:20190623-2
CREATE TABLE `article_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `articleid` int(11) NOT NULL COMMENT '文章id',
  `userid` int(11) NOT NULL COMMENT '用户id',
  `parentid` int(11) DEFAULT NULL COMMENT '父级id',
  `comment` text COMMENT '评论',
  `replier_id` int(11) DEFAULT NULL COMMENT '回复评论人id',
  `replier_name` varchar(255) DEFAULT NULL COMMENT '回复评论人的姓名',
  `create_time` varchar(255) DEFAULT NULL COMMENT '评论时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章评论';

--changeset smallsnail-wh:20190623-3
CREATE TABLE `email` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `title` varchar(100) DEFAULT NULL COMMENT '标题',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `name` varchar(50) DEFAULT NULL COMMENT '姓名',
  `content` text NOT NULL COMMENT '内容',
  `createtime` varchar(255) DEFAULT NULL,
  `userid` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_name` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='email';

--changeset smallsnail-wh:20190623-4
CREATE TABLE `interest` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `info` text NOT NULL COMMENT '简介',
  `content` text NOT NULL COMMENT '内容',
  `image` varchar(255) DEFAULT NULL COMMENT '图片url',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `banner` int(1) DEFAULT '0' COMMENT '是否加入轮播（0:不加入，1:加入）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='兴趣表';

--changeset smallsnail-wh:20190623-5
CREATE TABLE `msg_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `ownerid` int(11) NOT NULL COMMENT '帖子所有者id',
  `form` int(1) DEFAULT NULL COMMENT '消息类型（0：兴趣回帖，1：文章评论/回复）',
  `reply_card_id` int(10) DEFAULT NULL COMMENT '帖子回复id（form=0有效）',
  `comment_id` int(11) DEFAULT NULL COMMENT '文章评论id（form=1有效）',
  `replytime` varchar(255) DEFAULT NULL COMMENT '回复时间',
  `isread` int(1) DEFAULT '0' COMMENT '是否已读(0:未读，1:已读)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消息记录表';

--changeset smallsnail-wh:20190623-6
CREATE TABLE `oauth_client_details` (
  `client_id` varchar(255) NOT NULL,
  `resource_ids` varchar(255) DEFAULT NULL,
  `client_secret` varchar(255) DEFAULT NULL,
  `scope` varchar(255) DEFAULT NULL,
  `authorized_grant_types` varchar(255) DEFAULT NULL,
  `web_server_redirect_uri` varchar(255) DEFAULT NULL,
  `authorities` varchar(255) DEFAULT NULL,
  `access_token_validity` int(11) DEFAULT NULL,
  `refresh_token_validity` int(11) DEFAULT NULL,
  `additional_information` varchar(255) DEFAULT NULL,
  `autoapprove` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
--changeset smallsnail-wh:20190623-6-1
INSERT INTO `oauth_client_details` VALUES ('client',NULL,'{noop}secret','all','password,authorization_code,refresh_token,implicit,client_credentials',NULL,NULL,NULL,NULL,NULL,NULL);

--changeset smallsnail-wh:20190623-7
CREATE TABLE `post_card` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `title` varchar(100) DEFAULT NULL COMMENT '标题',
  `content` text NOT NULL COMMENT '内容',
  `interestid` int(11) DEFAULT NULL COMMENT '兴趣id',
  `createtime` varchar(255) DEFAULT NULL COMMENT '创建时间',
  `replytime` varchar(255) DEFAULT NULL COMMENT '最新回复时间',
  `userid` int(11) DEFAULT NULL COMMENT '用户名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='帖子表';

--changeset smallsnail-wh:20190623-8
CREATE TABLE `reply_card` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `content` text NOT NULL COMMENT '内容',
  `postcardid` int(11) DEFAULT NULL COMMENT '帖子id',
  `createtime` varchar(255) DEFAULT NULL COMMENT '创建时间',
  `userid` int(11) NOT NULL COMMENT '回复用户id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='回帖表';

--changeset smallsnail-wh:20190623-9
CREATE TABLE `r_user_role` (
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `role_id` int(11) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户-角色关系表';
--changeset smallsnail-wh:20190623-9-1
INSERT INTO `r_user_role` VALUES (1,1);

--changeset smallsnail-wh:20190623-10
CREATE TABLE `sys_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(50) DEFAULT NULL COMMENT '菜单名',
  `url` varchar(255) DEFAULT NULL COMMENT 'url',
  `parent_id` int(11) DEFAULT NULL COMMENT '父类id',
  `sort` tinyint(4) DEFAULT NULL COMMENT '排序',
  `remark` text COMMENT '描述',
  `icon` varchar(30) DEFAULT NULL COMMENT '图标',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统菜单';
--changeset smallsnail-wh:20190623-10-1
INSERT INTO `sys_menu` VALUES (1,'系统管理',' ',0,1,NULL,'md-settings'),(2,'轮播管理',' ',0,2,NULL,'logo-snapchat'),(3,'兴趣管理',' ',0,3,NULL,'logo-reddit'),(4,'发帖管理',' ',0,4,NULL,'md-chatboxes'),(5,'邮件管理',' ',0,5,NULL,'ios-mail'),(6,'用户管理','/base/user',1,1,NULL,'ios-person'),(7,'菜单管理','/base/menu',1,2,NULL,'md-list-box'),(8,'角色管理','/base/role',1,3,NULL,'ios-people'),(9,'轮播','/base/banner',2,1,NULL,'logo-snapchat'),(10,'新建','/base/i-create',3,1,NULL,'md-checkmark-circle'),(11,'修改','/base/i-edit',3,2,NULL,'md-create'),(12,'删除','/base/i-delete',3,3,NULL,'md-remove-circle'),(13,'发帖管理','/base/card',4,1,NULL,'ios-create-outline'),(14,'邮件','/base/email',5,1,NULL,'ios-mail'),(15,'文章管理',NULL,0,6,NULL,'md-paper'),(16,'文章','/base/article',15,1,NULL,'md-paper');

--changeset smallsnail-wh:20190623-11
CREATE TABLE `sys_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `role` varchar(50) NOT NULL COMMENT '角色',
  `name` varchar(50) DEFAULT NULL COMMENT '角色名',
  `modules` text COMMENT '权限',
  `describe` text COMMENT '描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色表';
--changeset smallsnail-wh:20190623-11-1
INSERT INTO `sys_role` VALUES (1,'ROLE_ADMIN','超级管理员','4;5;6;7;8;9;10;11;14;1;12;13;16;','超级管理员，拥有全部权限。');

--changeset smallsnail-wh:20190623-12
CREATE TABLE `sys_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(50) DEFAULT NULL COMMENT '用户名',
  `login_name` varchar(50) DEFAULT NULL COMMENT '登录名',
  `password` varchar(255) DEFAULT NULL COMMENT '密码',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `usertype` int(1) NOT NULL DEFAULT '0' COMMENT '用户类型（0:普通用户，1:管理员）',
  `headimg` varchar(255) DEFAULT NULL COMMENT '头像url',
  `url` varchar(255) DEFAULT NULL COMMENT 'GitHub主页',
  `create_time` varchar(255) DEFAULT NULL COMMENT '注册时间',
  `githubid` varchar(255) DEFAULT NULL COMMENT 'github的login',
  `qqid` varchar(255) DEFAULT NULL COMMENT 'qq的openid',
  PRIMARY KEY (`id`),
  UNIQUE KEY `githubid_UNIQUE` (`githubid`),
  UNIQUE KEY `login_name_UNIQUE` (`login_name`),
  UNIQUE KEY `qqid_UNIQUE` (`qqid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户';
--changeset smallsnail-wh:20190623-12-1
INSERT INTO `sys_user` VALUES (1,'admin','admin','{bcrypt}$2a$10$D8E4cuanLviCCe/ASqBC7OZ84JYOH8IT4/y4JLAV/Pm/AdhzPcy2.','123@qq.com',1,NULL,NULL,'1531704654140',NULL,NULL);

--changeset smallsnail-wh:20190623-13
CREATE TABLE `sys_user_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `userid` int(11) NOT NULL COMMENT '用户id',
  `article_sign` int(1) DEFAULT '0' COMMENT '文章标志为（0:可发布文章，1:不可发布文章）',
  `info` varchar(255) DEFAULT NULL COMMENT '个人简介',
  `location` varchar(255) DEFAULT NULL COMMENT '所在位置',
  `skill` varchar(255) DEFAULT NULL COMMENT '技能',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户详情表';
--changeset smallsnail-wh:20190623-13-1
INSERT INTO `sys_user_detail` VALUES (1,1,0,'ni hao ','shanghai','java');

--changeset smallsnail-wh:20190623-14
CREATE TABLE `user_github` (
  `login` varchar(255) NOT NULL COMMENT 'github用户名',
  `avatar_url` varchar(255) DEFAULT NULL COMMENT '头像url',
  `html_url` varchar(255) DEFAULT NULL COMMENT 'github主页',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `userid` int(11) DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='github用户';

--changeset smallsnail-wh:20190623-15
CREATE TABLE `user_qq` (
  `openid` varchar(255) NOT NULL COMMENT 'openid',
  `nickname` varchar(255) DEFAULT NULL COMMENT '用户名',
  `figureurl_qq_1` varchar(255) DEFAULT NULL COMMENT '头像url',
  `gender` varchar(255) DEFAULT NULL COMMENT '性别',
  `userid` int(11) DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`openid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='qq用户';

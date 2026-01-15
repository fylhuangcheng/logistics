-- 创建数据库
CREATE DATABASE IF NOT EXISTS logistics CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE logistics;

-- ==================== 1. 基础表（先创建没有外键依赖的） ====================

-- 网点表
CREATE TABLE stations (
                          station_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '网点ID',
                          station_code VARCHAR(50) UNIQUE NOT NULL COMMENT '网点编码',
                          station_name VARCHAR(100) NOT NULL COMMENT '网点名称',
                          address VARCHAR(200) NOT NULL COMMENT '地址',
                          phone VARCHAR(20) COMMENT '联系电话',
                          status TINYINT DEFAULT 1 COMMENT '状态：1-启用，0-停用',
                          create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                          update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                          INDEX idx_station_code (station_code),
                          INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='网点表';

-- 用户表
CREATE TABLE users (
                       user_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
                       username VARCHAR(50) UNIQUE NOT NULL COMMENT '用户名',
                       password VARCHAR(100) NOT NULL COMMENT '密码',
                       real_name VARCHAR(50) NOT NULL COMMENT '真实姓名',
                       email VARCHAR(100) COMMENT '邮箱',
                       phone VARCHAR(20) COMMENT '手机号',
                       user_type TINYINT NOT NULL COMMENT '用户类型：1-系统管理员，2-司机，3-客户',
                       status TINYINT DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
                       create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                       update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                       INDEX idx_username (username),
                       INDEX idx_user_type (user_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 车辆表
CREATE TABLE vehicles (
                          vehicle_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '车辆ID',
                          license_plate VARCHAR(20) UNIQUE NOT NULL COMMENT '车牌号',
                          vehicle_type VARCHAR(50) NOT NULL COMMENT '车辆类型',
                          load_capacity DECIMAL(10,2) NOT NULL COMMENT '载重量(吨)',
                          status TINYINT DEFAULT 1 COMMENT '状态：1-空闲，2-运输中，3-维修中',
                          current_station_id INT COMMENT '当前位置网点ID',
                          driver_name VARCHAR(50) COMMENT '驾驶员姓名',
                          driver_phone VARCHAR(20) COMMENT '驾驶员电话',
                          current_driver_id INT COMMENT '当前司机ID（后添加外键）',
                          create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                          update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                          FOREIGN KEY (current_station_id) REFERENCES stations(station_id),
                          INDEX idx_license_plate (license_plate),
                          INDEX idx_status (status),
                          INDEX idx_current_station (current_station_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='车辆表';

-- ==================== 2. 司机表（需要用户表） ====================

CREATE TABLE drivers (
                         driver_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '司机ID',
                         user_id INT UNIQUE NOT NULL COMMENT '关联用户ID',
                         license_number VARCHAR(50) NOT NULL COMMENT '驾驶证号',
                         license_type VARCHAR(20) NOT NULL COMMENT '驾照类型：A1、A2、B1、B2等',
                         license_expiry_date DATE NOT NULL COMMENT '驾照有效期',
                         years_experience INT DEFAULT 0 COMMENT '驾龄(年)',
                         emergency_contact VARCHAR(50) COMMENT '紧急联系人',
                         emergency_phone VARCHAR(20) COMMENT '紧急联系电话',
                         health_status VARCHAR(20) DEFAULT '良好' COMMENT '健康状况',
                         total_mileage DECIMAL(10,2) DEFAULT 0 COMMENT '累计行驶里程(公里)',
                         safety_score DECIMAL(5,2) DEFAULT 100.00 COMMENT '安全评分(0-100)',
                         current_status TINYINT DEFAULT 1 COMMENT '当前状态：1-待命，2-出车中，3-休息，4-休假，5-培训',
                         assigned_vehicle_id INT COMMENT '当前分配车辆',
                         last_rest_time DATETIME COMMENT '上次休息时间',
                         create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                         update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                         FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                         FOREIGN KEY (assigned_vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE SET NULL,
                         INDEX idx_license_number (license_number),
                         INDEX idx_current_status (current_status),
                         INDEX idx_safety_score (safety_score)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='司机信息表';

-- 更新vehicles表的外键约束
ALTER TABLE vehicles
    ADD FOREIGN KEY (current_driver_id) REFERENCES drivers(driver_id) ON DELETE SET NULL;

-- ==================== 3. 订单表（需要网点、车辆、用户表） ====================

CREATE TABLE orders (
                        order_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '订单ID',
                        order_number VARCHAR(50) UNIQUE NOT NULL COMMENT '订单编号',
                        sender_name VARCHAR(100) NOT NULL COMMENT '寄件人姓名',
                        sender_phone VARCHAR(20) NOT NULL COMMENT '寄件人电话',
                        sender_address VARCHAR(200) NOT NULL COMMENT '寄件地址',
                        receiver_name VARCHAR(100) NOT NULL COMMENT '收件人姓名',
                        receiver_phone VARCHAR(20) NOT NULL COMMENT '收件人电话',
                        receiver_address VARCHAR(200) NOT NULL COMMENT '收件地址',
                        goods_type VARCHAR(50) NOT NULL COMMENT '货物类型',
                        weight DECIMAL(10,2) NOT NULL COMMENT '重量(kg)',
                        volume DECIMAL(10,2) COMMENT '体积(m³)',
                        freight DECIMAL(10,2) NOT NULL COMMENT '运费',
                        status TINYINT DEFAULT 1 COMMENT '状态：1-已下单，2-已揽收，3-运输中，4-已到达，5-已签收',
                        start_station_id INT COMMENT '始发网点ID',
                        current_station_id INT COMMENT '当前网点ID',
                        end_station_id INT COMMENT '目的网点ID',
                        vehicle_id INT COMMENT '运输车辆ID',
                        transport_task_id INT COMMENT '运输任务ID（后添加外键）',
                        create_user_id INT COMMENT '创建用户ID',
                        create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                        update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                        expected_arrival_time DATETIME COMMENT '预计到达时间',
                        actual_arrival_time DATETIME COMMENT '实际到达时间',
                        remark TEXT COMMENT '备注',
                        FOREIGN KEY (start_station_id) REFERENCES stations(station_id),
                        FOREIGN KEY (current_station_id) REFERENCES stations(station_id),
                        FOREIGN KEY (end_station_id) REFERENCES stations(station_id),
                        FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
                        FOREIGN KEY (create_user_id) REFERENCES users(user_id),
                        INDEX idx_order_number (order_number),
                        INDEX idx_status (status),
                        INDEX idx_create_time (create_time),
                        INDEX idx_sender_phone (sender_phone),
                        INDEX idx_receiver_phone (receiver_phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- ==================== 4. 运输任务表（需要司机、车辆、网点、用户表） ====================

CREATE TABLE transport_tasks (
                                 task_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '任务ID',
                                 task_number VARCHAR(50) UNIQUE NOT NULL COMMENT '任务编号',
                                 task_type TINYINT NOT NULL COMMENT '任务类型：1-干线运输，2-支线配送，3-市内配送，4-跨省运输',
                                 order_ids JSON COMMENT '关联订单ID数组（支持一单多任务，一任务多订单）',
                                 vehicle_id INT NOT NULL COMMENT '运输车辆ID',
                                 driver_id INT NOT NULL COMMENT '执行司机ID',
                                 start_station_id INT NOT NULL COMMENT '始发网点ID',
                                 end_station_id INT NOT NULL COMMENT '目的网点ID',
                                 planned_departure_time DATETIME NOT NULL COMMENT '计划发车时间',
                                 planned_arrival_time DATETIME NOT NULL COMMENT '计划到达时间',
                                 actual_departure_time DATETIME COMMENT '实际发车时间',
                                 actual_arrival_time DATETIME COMMENT '实际到达时间',
                                 estimated_distance DECIMAL(10,2) COMMENT '预计距离(公里)',
                                 actual_distance DECIMAL(10,2) COMMENT '实际距离(公里)',
                                 estimated_duration_minutes INT COMMENT '预计时长(分钟)',
                                 task_status TINYINT NOT NULL DEFAULT 1 COMMENT '任务状态：1-待分配，2-已调度，3-装车中，4-运输中，5-已到达，6-卸货中，7-已完成，8-已取消',
                                 route_info TEXT COMMENT '路线信息',
                                 weather_conditions VARCHAR(50) COMMENT '天气状况',
                                 traffic_conditions VARCHAR(50) COMMENT '路况信息',
                                 fuel_consumption DECIMAL(10,2) COMMENT '油耗(升)',
                                 task_priority TINYINT DEFAULT 3 COMMENT '优先级：1-紧急，2-高，3-普通，4-低',
                                 delay_reason TEXT COMMENT '延误原因',
                                 completion_notes TEXT COMMENT '完成说明',
                                 supervisor_id INT COMMENT '调度员/主管ID（管理员）',
                                 create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                 FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
                                 FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
                                 FOREIGN KEY (start_station_id) REFERENCES stations(station_id),
                                 FOREIGN KEY (end_station_id) REFERENCES stations(station_id),
                                 FOREIGN KEY (supervisor_id) REFERENCES users(user_id),
                                 INDEX idx_task_number (task_number),
                                 INDEX idx_task_status (task_status),
                                 INDEX idx_driver_vehicle (driver_id, vehicle_id),
                                 INDEX idx_planned_time (planned_departure_time, planned_arrival_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='运输任务表';

-- 更新orders表的外键约束
ALTER TABLE orders
    ADD FOREIGN KEY (transport_task_id) REFERENCES transport_tasks(task_id) ON DELETE SET NULL;

-- ==================== 5. 货物明细表（需要订单表） ====================

CREATE TABLE cargo_items (
                             cargo_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '货物ID',
                             order_id INT NOT NULL COMMENT '关联订单ID',
                             cargo_code VARCHAR(50) COMMENT '货物编码（条形码）',
                             cargo_name VARCHAR(100) NOT NULL COMMENT '货物名称',
                             cargo_type VARCHAR(30) NOT NULL COMMENT '货物类别：普通、易碎、危险品、冷藏、大件',
                             quantity INT NOT NULL DEFAULT 1 COMMENT '数量',
                             unit VARCHAR(20) DEFAULT '件' COMMENT '单位：件、箱、桶、袋等',
                             unit_weight DECIMAL(10,3) COMMENT '单件重量(kg)',
                             unit_volume DECIMAL(10,3) COMMENT '单件体积(m³)',
                             total_weight DECIMAL(10,2) COMMENT '总重量(kg)',
                             total_volume DECIMAL(10,2) COMMENT '总体积(m³)',
                             declared_value DECIMAL(10,2) COMMENT '申报价值',
                             insurance_amount DECIMAL(10,2) COMMENT '保险金额',
                             packaging_type VARCHAR(30) COMMENT '包装类型：纸箱、木箱、托盘、编织袋',
                             special_requirements TEXT COMMENT '特殊要求',
                             storage_conditions VARCHAR(50) COMMENT '存储条件：常温、冷藏、冷冻',
                             current_location_type TINYINT COMMENT '当前位置类型：1-仓库，2-在途，3-已交付',
                             current_station_id INT COMMENT '当前所在网点ID',
                             status TINYINT DEFAULT 1 COMMENT '状态：1-待揽收，2-已入库，3-在途中，4-已到达，5-待配送，6-已签收',
                             last_scan_time DATETIME COMMENT '最后一次扫描时间',
                             create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                             update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                             FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
                             FOREIGN KEY (current_station_id) REFERENCES stations(station_id) ON DELETE SET NULL,
                             INDEX idx_order_id (order_id),
                             INDEX idx_cargo_code (cargo_code),
                             INDEX idx_status (status),
                             INDEX idx_cargo_type (cargo_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='货物明细表';

-- ==================== 6. 费用明细表（需要订单、运输任务、用户表） ====================

CREATE TABLE cost_details (
                              cost_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '费用ID',
                              order_id INT COMMENT '关联订单ID',
                              task_id INT COMMENT '关联运输任务ID',
                              cost_type TINYINT NOT NULL COMMENT '费用类型：1-运费，2-保险费，3-装卸费，4-仓储费，5-燃油附加费，6-过路费，7-其他',
                              cost_category TINYINT NOT NULL COMMENT '费用类别：1-收入（应收），2-支出（应付）',
                              amount DECIMAL(10,2) NOT NULL COMMENT '金额',
                              currency VARCHAR(3) DEFAULT 'CNY' COMMENT '币种',
                              payer_id INT COMMENT '付款方ID（关联用户表）',
                              payee_id INT COMMENT '收款方ID（关联用户表）',
                              payment_status TINYINT DEFAULT 1 COMMENT '支付状态：1-未支付，2-部分支付，3-已支付，4-已退款',
                              payment_method VARCHAR(20) COMMENT '支付方式：现金、转账、支付宝、微信',
                              payment_time DATETIME COMMENT '支付时间',
                              invoice_number VARCHAR(50) COMMENT '发票号码',
                              invoice_status TINYINT DEFAULT 0 COMMENT '发票状态：0-未开票，1-已申请，2-已开票，3-已寄送',
                              cost_description TEXT COMMENT '费用说明',
                              cost_time DATETIME COMMENT '费用发生时间',
                              accounted_by INT COMMENT '记账人ID（管理员）',
                              accounted_time DATETIME COMMENT '记账时间',
                              create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                              update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                              FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE SET NULL,
                              FOREIGN KEY (task_id) REFERENCES transport_tasks(task_id) ON DELETE SET NULL,
                              FOREIGN KEY (payer_id) REFERENCES users(user_id) ON DELETE SET NULL,
                              FOREIGN KEY (payee_id) REFERENCES users(user_id) ON DELETE SET NULL,
                              FOREIGN KEY (accounted_by) REFERENCES users(user_id) ON DELETE SET NULL,
                              INDEX idx_order_cost (order_id, cost_type),
                              INDEX idx_task_cost (task_id),
                              INDEX idx_payment_status (payment_status),
                              INDEX idx_cost_time (cost_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='费用明细表';

-- ==================== 7. 插入测试数据 ====================

-- 插入网点数据
INSERT INTO stations (station_code, station_name, address, phone) VALUES
                                                                      ('BJ001', '北京转运中心', '北京市朝阳区物流园区1号', '010-12345678'),
                                                                      ('SH001', '上海分拨中心', '上海市浦东新区物流基地2号', '021-87654321'),
                                                                      ('GZ001', '广州配送中心', '广州市白云区物流园3号', '020-33334444');

-- 插入车辆数据
INSERT INTO vehicles (license_plate, vehicle_type, load_capacity, status, current_station_id, driver_name, driver_phone) VALUES
                                                                                                                             ('京A12345', '重型货车', 20.00, 1, 1, '赵六', '13800138001'),
                                                                                                                             ('沪B67890', '中型货车', 10.00, 1, 2, '钱七', '13800138002'),
                                                                                                                             ('粤C54321', '厢式货车', 5.00, 1, 3, '孙八', '13800138003');

-- 插入用户数据（简化用户类型：1-管理员，2-司机，3-客户）
INSERT INTO users (username, password, real_name, email, phone, user_type) VALUES
                                                                               ('admin', 'e10adc3949ba59abbe56e057f20f883e', '系统管理员', 'admin@logistics.com', '13800138000', 1),
                                                                               ('customer1', 'e10adc3949ba59abbe56e057f20f883e', '张三客户', 'customer1@email.com', '13800138222', 3),
                                                                               ('driver1', 'e10adc3949ba59abbe56e057f20f883e', '赵六司机', 'driver1@logistics.com', '13800138001', 2),
                                                                               ('driver2', 'e10adc3949ba59abbe56e057f20f883e', '钱七司机', 'driver2@logistics.com', '13800138002', 2);

-- 插入司机数据
INSERT INTO drivers (user_id, license_number, license_type, license_expiry_date, years_experience, emergency_contact, emergency_phone, assigned_vehicle_id) VALUES
                                                                                                                                                                (3, '130101198001011234', 'A1', '2028-12-31', 10, '赵六妻子', '13800138111', 1),
                                                                                                                                                                (4, '130101198502028765', 'A2', '2027-06-30', 8, '钱七父亲', '13800138222', 2);

-- 更新车辆表的当前司机
UPDATE vehicles SET current_driver_id = 1 WHERE license_plate = '京A12345';
UPDATE vehicles SET current_driver_id = 2 WHERE license_plate = '沪B67890';

-- 插入订单数据
INSERT INTO orders (order_number, sender_name, sender_phone, sender_address, receiver_name, receiver_phone, receiver_address, goods_type, weight, volume, freight, status, start_station_id, current_station_id, end_station_id, create_user_id) VALUES
                                                                                                                                                                                                                                                     ('ORD20231220001', '刘一', '13911112222', '北京市朝阳区建国路100号', '陈二', '13933334444', '上海市浦东新区世纪大道200号', '电子产品', 5.5, 0.2, 150.00, 3, 1, 2, 2, 2),
                                                                                                                                                                                                                                                     ('ORD20231220002', '张三', '13955556666', '广州市天河区天河路300号', '李四', '13977778888', '北京市海淀区中关村400号', '服装', 10.0, 0.5, 200.00, 2, 3, 3, 1, 2);

-- 插入运输任务数据（supervisor_id关联管理员）
INSERT INTO transport_tasks (task_number, task_type, order_ids, vehicle_id, driver_id, start_station_id, end_station_id, planned_departure_time, planned_arrival_time, estimated_distance, task_status, supervisor_id) VALUES
                                                                                                                                                                                                                           ('TASK2023122001', 4, '[1]', 1, 1, 1, 2, '2023-12-20 08:00:00', '2023-12-21 18:00:00', 1200.00, 4, 1),
                                                                                                                                                                                                                           ('TASK2023122002', 2, '[2]', 2, 2, 3, 1, '2023-12-21 09:00:00', '2023-12-22 20:00:00', 1800.00, 2, 1);

-- 更新订单的运输任务关联
UPDATE orders SET transport_task_id = 1 WHERE order_id = 1;
UPDATE orders SET transport_task_id = 2 WHERE order_id = 2;

-- 更新订单的车辆ID
UPDATE orders o
    JOIN transport_tasks tt ON o.transport_task_id = tt.task_id
SET o.vehicle_id = tt.vehicle_id
WHERE o.order_id IN (1, 2);

-- 插入货物明细数据
INSERT INTO cargo_items (order_id, cargo_name, cargo_type, quantity, unit, unit_weight, total_weight, declared_value, packaging_type, status, current_station_id) VALUES
                                                                                                                                                                      (1, 'iPhone 15 Pro Max', '电子产品', 5, '台', 0.240, 1.200, 49999.00, '纸箱', 3, 2),
                                                                                                                                                                      (1, 'MacBook Pro 16寸', '电子产品', 3, '台', 2.200, 6.600, 35997.00, '纸箱', 3, 2),
                                                                                                                                                                      (2, '男士冬季羽绒服', '服装', 50, '件', 0.800, 40.000, 50000.00, '编织袋', 2, 3);

-- 插入费用明细数据（accounted_by关联管理员）
INSERT INTO cost_details (order_id, task_id, cost_type, cost_category, amount, payer_id, payee_id, payment_status, cost_description, accounted_by) VALUES
                                                                                                                                                       (1, 1, 1, 1, 150.00, 2, 1, 3, '订单基础运费', 1),
                                                                                                                                                       (1, 1, 2, 1, 50.00, 2, 1, 1, '货物保险费', 1);
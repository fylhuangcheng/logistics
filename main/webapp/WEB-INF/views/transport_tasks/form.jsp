<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<div class="card">
    <div class="card-header">
        <h5 class="mb-0">${empty transportTask ? '新增运输任务' : '编辑运输任务'}</h5>
    </div>
    <div class="card-body">
        <div id="errorAlert" class="alert alert-danger d-none"></div>

        <div id="transportTaskForm">
            <c:if test="${not empty transportTask}">
                <input type="hidden" id="taskId" value="${transportTask.taskId}">
            </c:if>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="taskNumber" class="form-label required">任务编号</label>
                        <input type="text" class="form-control" id="taskNumber" name="taskNumber"
                               value="${transportTask.taskNumber}" required maxlength="50">
                        <div class="invalid-feedback">请输入任务编号</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="taskType" class="form-label required">任务类型</label>
                        <select class="form-select" id="taskType" name="taskType" required>
                            <option value="">请选择任务类型</option>
                            <option value="1" ${transportTask.taskType == 1 ? 'selected' : ''}>普通运输</option>
                            <option value="2" ${transportTask.taskType == 2 ? 'selected' : ''}>加急运输</option>
                            <option value="3" ${transportTask.taskType == 3 ? 'selected' : ''}>冷链运输</option>
                            <option value="4" ${transportTask.taskType == 4 ? 'selected' : ''}>危险品运输</option>
                            <option value="5" ${transportTask.taskType == 5 ? 'selected' : ''}>特殊货物运输</option>
                        </select>
                        <div class="invalid-feedback">请选择任务类型</div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="taskPriority" class="form-label">优先级</label>
                        <select class="form-select" id="taskPriority" name="taskPriority">
                            <option value="1" ${transportTask.taskPriority == 1 ? 'selected' : ''}>高</option>
                            <option value="2" ${empty transportTask or transportTask.taskPriority == 2 ? 'selected' : ''}>中</option>
                            <option value="3" ${transportTask.taskPriority == 3 ? 'selected' : ''}>低</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="supervisorId" class="form-label">负责人</label>
                        <select class="form-select" id="supervisorId" name="supervisorId">
                            <option value="">请选择负责人</option>
                            <c:if test="${not empty supervisors}">
                                <c:forEach items="${supervisors}" var="user">
                                    <option value="${user.userId}"
                                        ${transportTask.supervisorId == user.userId ? 'selected' : ''}>
                                            ${user.username}
                                    </option>
                                </c:forEach>
                            </c:if>
                        </select>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="startStationId" class="form-label required">始发网点</label>
                        <select class="form-select" id="startStationId" name="startStationId" required>
                            <option value="">请选择始发网点</option>
                            <c:if test="${not empty stations}">
                                <c:forEach items="${stations}" var="station">
                                    <option value="${station.stationId}"
                                        ${transportTask.startStationId == station.stationId ? 'selected' : ''}>
                                            ${station.stationName}
                                    </option>
                                </c:forEach>
                            </c:if>
                        </select>
                        <div class="invalid-feedback">请选择始发网点</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="endStationId" class="form-label required">目的网点</label>
                        <select class="form-select" id="endStationId" name="endStationId" required>
                            <option value="">请选择目的网点</option>
                            <c:if test="${not empty stations}">
                                <c:forEach items="${stations}" var="station">
                                    <option value="${station.stationId}"
                                        ${transportTask.endStationId == station.stationId ? 'selected' : ''}>
                                            ${station.stationName}
                                    </option>
                                </c:forEach>
                            </c:if>
                        </select>
                        <div class="invalid-feedback">请选择目的网点</div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="estimatedDistance" class="form-label">预计距离(km)</label>
                        <input type="number" class="form-control" id="estimatedDistance" name="estimatedDistance"
                               value="${transportTask.estimatedDistance}" min="0" step="0.1">
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="estimatedDurationMinutes" class="form-label">预计时长(分钟)</label>
                        <input type="number" class="form-control" id="estimatedDurationMinutes" name="estimatedDurationMinutes"
                               value="${transportTask.estimatedDurationMinutes}" min="0">
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="taskStatus" class="form-label">任务状态</label>
                        <select class="form-select" id="taskStatus" name="taskStatus">
                            <option value="1" ${empty transportTask or transportTask.taskStatus == 1 ? 'selected' : ''}>待分配</option>
                            <option value="2" ${transportTask.taskStatus == 2 ? 'selected' : ''}>已分配</option>
                            <option value="3" ${transportTask.taskStatus == 3 ? 'selected' : ''}>运输中</option>
                            <option value="4" ${transportTask.taskStatus == 4 ? 'selected' : ''}>已完成</option>
                            <option value="5" ${transportTask.taskStatus == 5 ? 'selected' : ''}>已取消</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="mb-3">
                    <label for="plannedDepartureTime" class="form-label required">计划出发时间</label>
                    <input type="datetime-local" class="form-control" id="plannedDepartureTime" name="plannedDepartureTime"
                           value="<fmt:formatDate value="${transportTask.plannedDepartureTime}" pattern="yyyy-MM-dd'T'HH:mm" />" required>
                    <div class="invalid-feedback">请选择计划出发时间</div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="mb-3">
                    <label for="plannedArrivalTime" class="form-label required">计划到达时间</label>
                    <input type="datetime-local" class="form-control" id="plannedArrivalTime" name="plannedArrivalTime"
                           value="<fmt:formatDate value="${transportTask.plannedArrivalTime}" pattern="yyyy-MM-dd'T'HH:mm" />" required>
                    <div class="invalid-feedback">请选择计划到达时间</div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="mb-3">
                    <label for="actualDepartureTime" class="form-label">实际出发时间</label>
                    <input type="datetime-local" class="form-control" id="actualDepartureTime" name="actualDepartureTime"
                           value="<fmt:formatDate value="${transportTask.actualDepartureTime}" pattern="yyyy-MM-dd'T'HH:mm" />">
                </div>
            </div>
            <div class="col-md-6">
                <div class="mb-3">
                    <label for="actualArrivalTime" class="form-label">实际到达时间</label>
                    <input type="datetime-local" class="form-control" id="actualArrivalTime" name="actualArrivalTime"
                           value="<fmt:formatDate value="${transportTask.actualArrivalTime}" pattern="yyyy-MM-dd'T'HH:mm" />">
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="vehicleId" class="form-label required">分配车辆</label>
                        <select class="form-select" id="vehicleId" name="vehicleId" required>
                            <option value="">请选择车辆</option>
                            <c:if test="${not empty vehicles}">
                                <c:forEach items="${vehicles}" var="vehicle">
                                    <option value="${vehicle.vehicleId}"
                                        ${transportTask.vehicleId == vehicle.vehicleId ? 'selected' : ''}>
                                            ${vehicle.licensePlate} (${vehicle.vehicleType})
                                    </option>
                                </c:forEach>
                            </c:if>
                        </select>
                        <div class="invalid-feedback">请选择分配车辆</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="driverId" class="form-label required">分配司机</label>
                        <select class="form-select" id="driverId" name="driverId" required>
                            <option value="">请选择司机</option>
                            <c:if test="${not empty drivers}">
                                <c:forEach items="${drivers}" var="driver">
                                    <option value="${driver.driverId}"
                                        ${transportTask.driverId == driver.driverId ? 'selected' : ''}>
                                        <c:choose>
                                            <c:when test="${not empty driver.user}">
                                                ${driver.user.realName} (${driver.user.phone})
                                            </c:when>
                                            <c:otherwise>
                                                司机ID: ${driver.driverId} (未关联用户)
                                            </c:otherwise>
                                        </c:choose>
                                    </option>
                                </c:forEach>
                            </c:if>
                        </select>
                        <div class="invalid-feedback">请选择分配司机</div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="actualDistance" class="form-label">实际距离(km)</label>
                        <input type="number" class="form-control" id="actualDistance" name="actualDistance"
                               value="${transportTask.actualDistance}" min="0" step="0.1">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="fuelConsumption" class="form-label">燃油消耗(L)</label>
                        <input type="number" class="form-control" id="fuelConsumption" name="fuelConsumption"
                               value="${transportTask.fuelConsumption}" min="0" step="0.1">
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <label for="routeInfo" class="form-label">路线信息</label>
                <textarea class="form-control" id="routeInfo" name="routeInfo"
                          rows="3" maxlength="500">${transportTask.routeInfo}</textarea>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="weatherConditions" class="form-label">天气状况</label>
                        <input type="text" class="form-control" id="weatherConditions" name="weatherConditions"
                               value="${transportTask.weatherConditions}" maxlength="100">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="trafficConditions" class="form-label">交通状况</label>
                        <input type="text" class="form-control" id="trafficConditions" name="trafficConditions"
                               value="${transportTask.trafficConditions}" maxlength="100">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="delayReason" class="form-label">延误原因</label>
                        <textarea class="form-control" id="delayReason" name="delayReason"
                                  rows="2" maxlength="500">${transportTask.delayReason}</textarea>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="completionNotes" class="form-label">完成备注</label>
                        <textarea class="form-control" id="completionNotes" name="completionNotes"
                                  rows="2" maxlength="500">${transportTask.completionNotes}</textarea>
                    </div>
                </div>
            </div>

            <!-- 关联订单选择 -->
            <!-- 关联订单选择 -->
            <div class="card mb-4">
                <div class="card-header">
                    <h6 class="mb-0">关联订单（可选）</h6>
                    <small class="text-muted">
                        可用订单: ${not empty orders ? orders.size() : 0} 个
                    </small>
                </div>
                <div class="card-body">
                    <div id="orderSelection">
                        <c:if test="${not empty orders}">
                            <div class="row">
                                <c:forEach items="${orders}" var="order">
                                    <div class="col-md-6">
                                        <div class="form-check mb-2">
                                                <%-- 复选框value存储orderId，但显示orderNumber --%>
                                            <input class="form-check-input order-checkbox" type="checkbox"
                                                   name="orderIds" value="${order.orderId}" <%-- 发送的是orderId --%>
                                                   id="order${order.orderId}"
                                                   <c:if test="${selectedOrderIds.contains(order.orderId)}">checked</c:if>>

                                            <label class="form-check-label" for="order${order.orderId}">
                                                    <%-- 显示orderNumber给用户看 --%>
                                                <strong>订单号: ${order.orderNumber}</strong>
                                                <br>
                                                <small class="text-muted">
                                                    发件人: ${order.senderName} |
                                                    货物: ${order.goodsType} |
                                                    状态:
                                                    <c:choose>
                                                        <c:when test="${order.status == 1}"><span class="badge bg-secondary">已下单</span></c:when>
                                                        <c:when test="${order.status == 2}"><span class="badge bg-primary">已揽收</span></c:when>
                                                        <c:when test="${order.status == 3}"><span class="badge bg-info">运输中</span></c:when>
                                                        <c:when test="${order.status == 4}"><span class="badge bg-warning">已到达</span></c:when>
                                                        <c:when test="${order.status == 5}"><span class="badge bg-success">已签收</span></c:when>
                                                        <c:otherwise><span class="badge bg-dark">未知</span></c:otherwise>
                                                    </c:choose>
                                                </small>
                                            </label>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                        <c:if test="${empty orders}">
                            <div class="alert alert-info">
                                <p>暂无可用订单数据</p>
                                <small>可能原因：</small>
                                <ul>
                                    <li>所有订单都已分配运输任务</li>
                                    <li>订单尚未到达可运输状态</li>
                                    <li>数据库中没有订单数据</li>
                                </ul>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <a href="${pageContext.request.contextPath}/transport_tasks" class="btn btn-secondary me-2">取消</a>
                <button type="button" class="btn btn-primary" onclick="submitTransportTaskForm()">
                    <span id="submitBtnText">${empty transportTask ? '创建任务' : '更新任务'}</span>
                    <span id="submitLoading" class="spinner-border spinner-border-sm d-none" role="status"></span>
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        console.log('运输任务表单页面加载完成');

        // 如果资源列表为空，加载资源
        <c:if test="${empty stations}">
        loadStations();
        </c:if>

        <c:if test="${empty vehicles}">
        loadVehicles();
        </c:if>

        <c:if test="${empty drivers}">
        loadDrivers();
        </c:if>

        <c:if test="${empty supervisors}">
        loadSupervisors();
        </c:if>

        <c:if test="${empty orders}">
        loadOrders();
        </c:if>

        // 实时检查任务编号是否重复
        $('#taskNumber').on('blur', function() {
            const taskNumber = $(this).val().trim();
            if (!taskNumber || $('#taskId').val()) return;

            $.ajax({
                url: '${pageContext.request.contextPath}/api/transport_tasks/number/' + encodeURIComponent(taskNumber),
                type: 'GET',
                success: function(response) {
                    if (response.code === 200 && response.data) {
                        $(this).addClass('is-invalid');
                        $(this).next('.invalid-feedback').text('任务编号已存在');
                    } else {
                        $(this).removeClass('is-invalid');
                    }
                }.bind(this)
            });
        });

        // 根据任务状态显示/隐藏实际时间
        $('#taskStatus').on('change', function() {
            const status = $(this).val();
            if (status >= 3) { // 运输中或已完成
                $('#actualDepartureTime').prop('required', true);
                if (status == 4) { // 已完成
                    $('#actualArrivalTime').prop('required', true);
                }
            } else {
                $('#actualDepartureTime').prop('required', false);
                $('#actualArrivalTime').prop('required', false);
            }
        });

        // 验证计划时间
        $('#plannedArrivalTime').on('change', function() {
            const departureTime = $('#plannedDepartureTime').val();
            const arrivalTime = $(this).val();

            if (departureTime && arrivalTime && departureTime > arrivalTime) {
                $(this).addClass('is-invalid');
                $(this).next('.invalid-feedback').text('计划到达时间不能早于出发时间');
            } else {
                $(this).removeClass('is-invalid');
            }
        });

        // 验证实际时间
        $('#actualArrivalTime').on('change', function() {
            const departureTime = $('#actualDepartureTime').val();
            const arrivalTime = $(this).val();

            if (departureTime && arrivalTime && departureTime > arrivalTime) {
                $(this).addClass('is-invalid');
                $(this).next('.invalid-feedback').text('实际到达时间不能早于出发时间');
            } else {
                $(this).removeClass('is-invalid');
            }
        });
    });

    // 加载站点列表
    function loadStations() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/stations/active',
            type: 'GET',
            success: function(response) {
                if (response.code === 200 && response.data) {
                    updateSelectOptions('#startStationId', response.data, '${transportTask.startStationId}', '请选择始发网点');
                    updateSelectOptions('#endStationId', response.data, '${transportTask.endStationId}', '请选择目的网点');
                }
            }
        });
    }

    // 加载车辆列表
    function loadVehicles() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/vehicles/search',
            type: 'GET',
            data: { status: '1,2', size: 100 }, // 空闲或运输中的车辆
            success: function(response) {
                if (response.code === 200 && response.data) {
                    updateSelectOptions('#vehicleId', response.data.list, '${transportTask.vehicleId}', '请选择车辆',
                        function(vehicle) {
                            return `${vehicle.licensePlate} (${vehicle.vehicleType})`;
                        });
                }
            }
        });
    }

    // 加载司机列表
    function loadDrivers() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/drivers/search',
            type: 'GET',
            data: { status: '1,2', size: 100 }, // 空闲或运输中的司机
            success: function(response) {
                if (response.code === 200 && response.data) {
                    updateSelectOptions('#driverId', response.data.list, '${transportTask.driverId}', '请选择司机',
                        function(driver) {
                            if (driver.user && driver.user.realName && driver.user.phone) {
                                return `${driver.user.realName} (${driver.user.phone})`;
                            } else if (driver.user && driver.user.realName) {
                                return `${driver.user.realName}`;
                            } else {
                                return `司机ID: ${driver.driverId} (未关联用户)`;
                            }
                        });
                }
            }
        });
    }

    // 加载负责人列表
    function loadSupervisors() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/users/search',
            type: 'GET',
            data: { role: 'admin,supervisor', size: 100 },
            success: function(response) {
                if (response.code === 200 && response.data) {
                    updateSelectOptions('#supervisorId', response.data.list, '${transportTask.supervisorId}', '请选择负责人',
                        function(user) {
                            return `${user.username}`;
                        });
                }
            }
        });
    }

    // 加载订单列表
    function loadOrders() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/orders/search',
            type: 'GET',
            data: {
                status: '2,3', // 已揽收或运输中的订单
                startStationId: $('#startStationId').val(),
                size: 100
            },
            success: function(response) {
                if (response.code === 200 && response.data) {
                    updateOrderCheckboxes(response.data.list);
                }
            }
        });
    }

    function updateSelectOptions(selector, data, currentValue, placeholder, formatter) {
        const $select = $(selector);
        $select.empty();
        $select.append(`<option value="">${placeholder}</option>`);

        const currentId = $('#taskId').val() ? currentValue : null;

        data.forEach(function(item) {
            const selected = currentId && item.id == currentId ? 'selected' : '';
            const displayText = formatter ? formatter(item) : item.name || item.stationName || item.username;
            $select.append(
                `<option value="${item.id || item.stationId || item.vehicleId || item.driverId || item.userId}" ${selected}>
                    ${displayText}
                </option>`
            );
        });
    }

    function updateOrderCheckboxes(orders) {
        const $container = $('#orderSelection');
        $container.empty();

        if (!orders || orders.length === 0) {
            $container.html('<p class="text-muted">暂无可用订单数据</p>');
            return;
        }

        // 使用 let 而不是 const
        let checkedOrders = [];

        // 获取服务器端传递的选中订单ID
        <c:if test="${not empty transportTask.orderIds}">
        try {
            const orderIdsJson = '${transportTask.orderIds}';
            if (orderIdsJson) {
                // 尝试解析JSON
                if (orderIdsJson.startsWith('[')) {
                    checkedOrders = JSON.parse(orderIdsJson);
                } else {
                    // 可能是逗号分隔的字符串
                    checkedOrders = orderIdsJson.split(',').map(id => parseInt(id)).filter(id => !isNaN(id));
                }
            }
        } catch (e) {
            console.error('解析订单ID失败:', e);
        }
        </c:if>

        let html = '<div class="row">';
        orders.forEach(function(order) {
            const orderIdNum = parseInt(order.orderId);
            const isChecked = checkedOrders.some(id => parseInt(id) === orderIdNum);

            html += `
            <div class="col-md-6">
                <div class="form-check mb-2">
                    <input class="form-check-input order-checkbox" type="checkbox"
                           name="orderIds" value="${order.orderId}"
                           id="order${order.orderId}" ${isChecked ? 'checked' : ''}>
                    <label class="form-check-label" for="order${order.orderId}">
                        ${order.orderNumber} - ${order.senderName} (${order.goodsType})
                    </label>
                </div>
            </div>
        `;
        });
        html += '</div>';

        $container.html(html);
    }

    // 根据始发网点筛选订单
    $('#startStationId').on('change', function() {
        loadOrders();
    });

    // 表单验证
    function validateTransportTaskForm() {
        let isValid = true;
        $('.invalid-feedback').hide();
        $('.is-invalid').removeClass('is-invalid');

        const requiredFields = ['taskNumber', 'taskType', 'startStationId', 'endStationId',
            'plannedDepartureTime', 'plannedArrivalTime'];

        requiredFields.forEach(function(fieldId) {
            const field = $('#' + fieldId);
            if (field.length) {
                const value = field.val();
                if (!value || value.toString().trim() === '') {
                    field.addClass('is-invalid');
                    field.next('.invalid-feedback').show();
                    isValid = false;
                }
            }
        });

        // 验证计划时间
        const departureTime = $('#plannedDepartureTime').val();
        const arrivalTime = $('#plannedArrivalTime').val();
        if (departureTime && arrivalTime && departureTime > arrivalTime) {
            $('#plannedArrivalTime').addClass('is-invalid');
            $('#plannedArrivalTime').next('.invalid-feedback').text('计划到达时间不能早于出发时间').show();
            isValid = false;
        }

        // 验证实际时间
        const actualDepartureTime = $('#actualDepartureTime').val();
        const actualArrivalTime = $('#actualArrivalTime').val();
        if (actualDepartureTime && actualArrivalTime && actualDepartureTime > actualArrivalTime) {
            $('#actualArrivalTime').addClass('is-invalid');
            $('#actualArrivalTime').next('.invalid-feedback').text('实际到达时间不能早于出发时间').show();
            isValid = false;
        }

        return isValid;
    }

    // 提交表单
    function submitTransportTaskForm() {
        console.log('提交运输任务表单');

        if (!validateTransportTaskForm()) {
            showAlert('error', '请填写完整的表单信息');
            return;
        }

        // 显示加载状态
        $('#submitBtnText').addClass('d-none');
        $('#submitLoading').removeClass('d-none');
        $('button[onclick="submitTransportTaskForm()"]').prop('disabled', true);

        // 收集表单数据
        const formData = {
            taskNumber: $('#taskNumber').val().trim(),
            taskType: parseInt($('#taskType').val()),
            taskPriority: parseInt($('#taskPriority').val()) || 2,
            startStationId: parseInt($('#startStationId').val()),
            endStationId: parseInt($('#endStationId').val()),
            estimatedDistance: $('#estimatedDistance').val() ? parseFloat($('#estimatedDistance').val()) : null,
            estimatedDurationMinutes: $('#estimatedDurationMinutes').val() ? parseInt($('#estimatedDurationMinutes').val()) : null,
            taskStatus: parseInt($('#taskStatus').val()) || 1,
            plannedDepartureTime: $('#plannedDepartureTime').val(),
            plannedArrivalTime: $('#plannedArrivalTime').val(),
            actualDepartureTime: $('#actualDepartureTime').val() || null,
            actualArrivalTime: $('#actualArrivalTime').val() || null,
            vehicleId: $('#vehicleId').val() ? parseInt($('#vehicleId').val()) : null,
            driverId: $('#driverId').val() ? parseInt($('#driverId').val()) : null,
            supervisorId: $('#supervisorId').val() ? parseInt($('#supervisorId').val()) : null,
            actualDistance: $('#actualDistance').val() ? parseFloat($('#actualDistance').val()) : null,
            fuelConsumption: $('#fuelConsumption').val() ? parseFloat($('#fuelConsumption').val()) : null,
            routeInfo: $('#routeInfo').val().trim() || null,
            weatherConditions: $('#weatherConditions').val().trim() || null,
            trafficConditions: $('#trafficConditions').val().trim() || null,
            delayReason: $('#delayReason').val().trim() || null,
            completionNotes: $('#completionNotes').val().trim() || null
        };

        // 收集关联订单
        const orderIds = [];
        $('.order-checkbox:checked').each(function() {
            orderIds.push($(this).val()); // 不要parseInt，直接使用字符串
        });
        if (orderIds.length > 0) {
            formData.orderIds = orderIds.join(','); // 改为逗号分隔的字符串
        } else {
            formData.orderIds = ''; // 或者不设置这个字段
        }

        // 如果是编辑，添加taskId
        const taskId = $('#taskId').val();
        if (taskId) {
            formData.taskId = parseInt(taskId);
        }

        const url = taskId
            ? '${pageContext.request.contextPath}/api/transport_tasks/' + taskId
            : '${pageContext.request.contextPath}/api/transport_tasks';
        const method = taskId ? 'PUT' : 'POST';

        Utils.showLoading('正在保存...');

        $.ajax({
            url: url,
            type: method,
            contentType: 'application/json',
            data: JSON.stringify(formData),
            success: function(response) {
                Utils.hideLoading();
                resetSubmitButton();

                if (response.code === 200) {
                    Utils.showSuccess(method === 'POST' ? '运输任务创建成功！' : '运输任务更新成功！');

                    setTimeout(function() {
                        window.location.href = '${pageContext.request.contextPath}/transport_tasks';
                    }, 1500);
                } else {
                    Utils.showError(response.message || '操作失败');

                    // 如果是任务编号重复的错误，高亮显示
                    if (response.message && response.message.includes('任务编号')) {
                        $('#taskNumber').addClass('is-invalid');
                        $('#taskNumber').next('.invalid-feedback').text(response.message).show();
                        $('#taskNumber').focus();
                    }
                }
            },
            error: function(xhr) {
                Utils.hideLoading();
                resetSubmitButton();

                let errorMessage = '请求失败，请检查网络连接';
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    errorMessage = xhr.responseJSON.message;
                }

                Utils.showError(errorMessage);
            }
        });
    }

    function resetSubmitButton() {
        $('#submitBtnText').removeClass('d-none');
        $('#submitLoading').addClass('d-none');
        $('button[onclick="submitTransportTaskForm()"]').prop('disabled', false);
    }

    function showAlert(type, message) {
        const $alert = $('#errorAlert');
        $alert.removeClass('d-none').text(message);

        if (type === 'error') {
            $alert.addClass('alert-danger').removeClass('alert-success');
        } else {
            $alert.addClass('alert-success').removeClass('alert-danger');
        }

        $('html, body').animate({ scrollTop: 0 }, 500);
    }
</script>
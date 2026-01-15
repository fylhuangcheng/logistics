<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header">
        <h5 class="mb-0">${empty order ? '新建订单' : '编辑订单'}</h5>
    </div>
    <div class="card-body">
        <!-- 错误提示容器 -->
        <div id="errorAlert" class="alert alert-danger d-none"></div>

        <!-- 使用div包装，表单将通过Ajax提交 -->
        <div id="orderForm">
            <c:if test="${not empty order}">
                <input type="hidden" id="orderId" value="${order.orderId}">
            </c:if>

            <!-- 订单基本信息 -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="orderNumber" class="form-label required">订单号</label>
                        <input type="text" class="form-control" id="orderNumber"
                               name="orderNumber" value="${order.orderNumber}"
                               required maxlength="50" readonly>
                        <div class="invalid-feedback">请输入订单号</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="goodsType" class="form-label required">货物类型</label>
                        <select class="form-select" id="goodsType" name="goodsType" required>
                            <option value="">请选择货物类型</option>
                            <option value="电子产品" ${order.goodsType == '电子产品' ? 'selected' : ''}>电子产品</option>
                            <option value="服装" ${order.goodsType == '服装' ? 'selected' : ''}>服装</option>
                            <option value="食品" ${order.goodsType == '食品' ? 'selected' : ''}>食品</option>
                            <option value="日用品" ${order.goodsType == '日用品' ? 'selected' : ''}>日用品</option>
                            <option value="家具" ${order.goodsType == '家具' ? 'selected' : ''}>家具</option>
                            <option value="其他" ${order.goodsType == '其他' ? 'selected' : ''}>其他</option>
                        </select>
                        <div class="invalid-feedback">请选择货物类型</div>
                    </div>
                </div>
            </div>

            <!-- 寄件人信息 -->
            <div class="card mb-4">
                <div class="card-header bg-light">
                    <h6 class="mb-0">寄件人信息</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="senderName" class="form-label required">寄件人姓名</label>
                                <input type="text" class="form-control" id="senderName" name="senderName"
                                       value="${order.senderName}" required maxlength="50">
                                <div class="invalid-feedback">请输入寄件人姓名</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="senderPhone" class="form-label required">联系电话</label>
                                <input type="tel" class="form-control" id="senderPhone" name="senderPhone"
                                       value="${order.senderPhone}" required maxlength="20">
                                <div class="invalid-feedback">请输入联系电话</div>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="senderAddress" class="form-label required">寄件地址</label>
                        <textarea class="form-control" id="senderAddress" name="senderAddress"
                                  rows="2" required maxlength="200">${order.senderAddress}</textarea>
                        <div class="invalid-feedback">请输入寄件地址</div>
                    </div>
                </div>
            </div>

            <!-- 收件人信息 -->
            <div class="card mb-4">
                <div class="card-header bg-light">
                    <h6 class="mb-0">收件人信息</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="receiverName" class="form-label required">收件人姓名</label>
                                <input type="text" class="form-control" id="receiverName" name="receiverName"
                                       value="${order.receiverName}" required maxlength="50">
                                <div class="invalid-feedback">请输入收件人姓名</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="receiverPhone" class="form-label required">联系电话</label>
                                <input type="tel" class="form-control" id="receiverPhone" name="receiverPhone"
                                       value="${order.receiverPhone}" required maxlength="20">
                                <div class="invalid-feedback">请输入联系电话</div>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="receiverAddress" class="form-label required">收件地址</label>
                        <textarea class="form-control" id="receiverAddress" name="receiverAddress"
                                  rows="2" required maxlength="200">${order.receiverAddress}</textarea>
                        <div class="invalid-feedback">请输入收件地址</div>
                    </div>
                </div>
            </div>

            <!-- 货物和运输信息 -->
            <div class="row">
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="weight" class="form-label required">重量(kg)</label>
                        <input type="number" class="form-control" id="weight" name="weight"
                               value="${order.weight}" required min="0.1" step="0.1">
                        <div class="invalid-feedback">请输入重量</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="volume" class="form-label">体积(m³)</label>
                        <input type="number" class="form-control" id="volume" name="volume"
                               value="${order.volume}" min="0" step="0.01">
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="freight" class="form-label required">运费(¥)</label>
                        <input type="number" class="form-control" id="freight" name="freight"
                               value="${order.freight}" required min="0" step="0.01">
                        <div class="invalid-feedback">请输入运费</div>
                    </div>
                </div>
            </div>

            <!-- 网点信息 -->
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="startStationId" class="form-label required">始发网点</label>
                        <select class="form-select" id="startStationId" name="startStationId" required>
                            <option value="">请选择始发网点</option>
                            <c:forEach items="${stations}" var="station">
                                <option value="${station.stationId}"
                                    ${order.startStationId == station.stationId ? 'selected' : ''}>
                                        ${station.stationName}
                                </option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback">请选择始发网点</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="endStationId" class="form-label required">目的网点</label>
                        <select class="form-select" id="endStationId" name="endStationId" required>
                            <option value="">请选择目的网点</option>
                            <c:forEach items="${stations}" var="station">
                                <option value="${station.stationId}"
                                    ${order.endStationId == station.stationId ? 'selected' : ''}>
                                        ${station.stationName}
                                </option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback">请选择目的网点</div>
                    </div>
                </div>
            </div>

            <!-- 订单状态 -->
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="status" class="form-label">订单状态</label>
                        <select class="form-select" id="status" name="status">
                            <option value="1" ${empty order or order.status == 1 ? 'selected' : ''}>已下单</option>
                            <option value="2" ${order.status == 2 ? 'selected' : ''}>已揽收</option>
                            <option value="3" ${order.status == 3 ? 'selected' : ''}>运输中</option>
                            <option value="4" ${order.status == 4 ? 'selected' : ''}>已到达</option>
                            <option value="5" ${order.status == 5 ? 'selected' : ''}>已签收</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="vehicleId" class="form-label">分配车辆</label>
                        <select class="form-select" id="vehicleId" name="vehicleId">
                            <option value="">不分配车辆</option>
                            <c:if test="${not empty availableVehicles}">
                                <c:forEach items="${availableVehicles}" var="vehicle">
                                    <option value="${vehicle.vehicleId}"
                                        ${order.vehicleId == vehicle.vehicleId ? 'selected' : ''}>
                                            ${vehicle.licensePlate} (${vehicle.vehicleType}, 载重:${vehicle.loadCapacity}吨)
                                    </option>
                                </c:forEach>
                            </c:if>
                        </select>
                    </div>
                </div>
            </div>

            <!-- 备注 -->
            <div class="mb-3">
                <label for="remark" class="form-label">备注</label>
                <textarea class="form-control" id="remark" name="remark"
                          rows="3" maxlength="500">${order.remark}</textarea>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary me-2">取消</a>
                <button type="button" class="btn btn-primary" onclick="submitForm()">
                    <span id="submitBtnText">${empty order ? '创建订单' : '更新订单'}</span>
                    <span id="submitLoading" class="spinner-border spinner-border-sm d-none" role="status"></span>
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        console.log('订单表单页面加载完成');

        // 如果是新建订单，自动生成订单号
        if (!$('#orderNumber').val() || $('#orderNumber').val().trim() === '') {
            generateOrderNumber();
        }

        // 重量改变时自动计算运费
        $('#weight').on('change', function() {
            const weight = parseFloat($(this).val()) || 0;
            const freight = weight * 5; // 简单运费计算：每公斤5元
            if (freight > 0) {
                $('#freight').val(freight.toFixed(2));
            }
        });

        // 实时检查订单号是否重复
        $('#orderNumber').on('blur', function() {
            const orderNumber = $(this).val();
            if (orderNumber.trim() === '' || $('#orderId').val()) return;

            $.ajax({
                url: '${pageContext.request.contextPath}/api/orders/number/' + encodeURIComponent(orderNumber),
                type: 'GET',
                success: function(response) {
                    if (response.code === 200 && response.data) {
                        $('#orderNumber').addClass('is-invalid');
                        $('#orderNumber').next('.invalid-feedback').text('订单号已存在');
                    } else {
                        $('#orderNumber').removeClass('is-invalid');
                    }
                }
            });
        });

        // ========== 新增：当寄件人姓名输入"张三"时，自动填充电话 ==========
        $('#senderName').on('blur', function() {
            const senderName = $(this).val().trim();

            // 如果寄件人姓名是"张三"，自动设置电话为"13800138222"
            if (senderName === '张三') {
                $('#senderPhone').val('13800138222');

                // 可选：显示一个提示消息
                Utils.showInfo('已根据寄件人姓名自动填充联系电话');

                // 验证电话号码格式
                const phoneRegex = /^1[3-9]\d{9}$/;
                if (phoneRegex.test('13800138222')) {
                    $('#senderPhone').removeClass('is-invalid');
                    $('#senderPhone').next('.invalid-feedback').hide();
                }
            }
        });

        // 额外：当用户尝试修改电话时，如果是张三的特殊号码，可以给个提示
        $('#senderPhone').on('focus', function() {
            const senderName = $('#senderName').val().trim();
            const phoneValue = $(this).val();

            // 如果当前是张三且电话是预设的13800138222，提示用户
            if (senderName === '张三' && phoneValue === '13800138222') {
                if (confirm('这是"张三"的预设电话号码，确定要修改吗？')) {
                    // 用户确认修改，不做任何操作
                } else {
                    // 用户取消修改，保持原值
                    $(this).val('13800138222');
                }
            }
        });
    });

    // 生成订单号的优化版本
    function generateOrderNumber() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/orders/generate-number',
            type: 'GET',
            beforeSend: function() {
                $('#orderNumber').prop('disabled', true).val('正在生成订单号...');
            },
            success: function(response) {
                if (response.code === 200 && response.data.orderNumber) {
                    $('#orderNumber').val(response.data.orderNumber);
                } else {
                    generateDefaultOrderNumber();
                }
            },
            error: function() {
                generateDefaultOrderNumber();
            },
            complete: function() {
                $('#orderNumber').prop('disabled', false);
            }
        });
    }

    // 根据始发网点获取可用车辆
    $('#startStationId').on('change', function() {
        const stationId = $(this).val();
        const weight = $('#weight').val();

        if (stationId && weight) {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/vehicles/available/' + stationId,
                type: 'GET',
                data: { minCapacity: weight },
                success: function(response) {
                    if (response.code === 200 && response.data) {
                        updateVehicleOptions(response.data);
                    }
                }
            });
        }
    });

    function updateVehicleOptions(vehicles) {
        const $select = $('#vehicleId');
        $select.empty();
        $select.append('<option value="">不分配车辆</option>');

        vehicles.forEach(function(vehicle) {
            $select.append(
                '<option value="' + vehicle.vehicleId + '">' +
                vehicle.licensePlate + ' (' + vehicle.vehicleType +
                ', 载重:' + vehicle.loadCapacity + '吨)' +
                '</option>'
            );
        });
    }

    // 表单验证
    function validateForm() {
        let isValid = true;
        $('.invalid-feedback').hide();
        $('.is-invalid').removeClass('is-invalid');

        // 验证必填字段
        const requiredFields = [
            'orderNumber', 'goodsType', 'senderName', 'senderPhone', 'senderAddress',
            'receiverName', 'receiverPhone', 'receiverAddress', 'weight', 'freight',
            'startStationId', 'endStationId'
        ];

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

        // 验证电话号码格式
        const phoneRegex = /^1[3-9]\d{9}$/;
        const senderPhone = $('#senderPhone').val();
        const receiverPhone = $('#receiverPhone').val();

        if (senderPhone && !phoneRegex.test(senderPhone)) {
            $('#senderPhone').addClass('is-invalid');
            $('#senderPhone').next('.invalid-feedback').text('请输入有效的手机号码').show();
            isValid = false;
        }

        if (receiverPhone && !phoneRegex.test(receiverPhone)) {
            $('#receiverPhone').addClass('is-invalid');
            $('#receiverPhone').next('.invalid-feedback').text('请输入有效的手机号码').show();
            isValid = false;
        }

        // 验证数字字段
        const weight = parseFloat($('#weight').val());
        if (isNaN(weight) || weight <= 0) {
            $('#weight').addClass('is-invalid');
            $('#weight').next('.invalid-feedback').text('请输入大于0的重量').show();
            isValid = false;
        }

        const freight = parseFloat($('#freight').val());
        if (isNaN(freight) || freight < 0) {
            $('#freight').addClass('is-invalid');
            $('#freight').next('.invalid-feedback').text('请输入有效的运费金额').show();
            isValid = false;
        }

        return isValid;
    }

    // 优化后的提交函数
    function submitForm() {
        console.log('提交订单表单');

        if (!validateForm()) {
            Utils.showError('请填写完整的表单信息');
            return;
        }

        // 收集表单数据
        const formData = {
            orderNumber: $('#orderNumber').val(),
            goodsType: $('#goodsType').val(),
            senderName: $('#senderName').val(),
            senderPhone: $('#senderPhone').val(),
            senderAddress: $('#senderAddress').val(),
            receiverName: $('#receiverName').val(),
            receiverPhone: $('#receiverPhone').val(),
            receiverAddress: $('#receiverAddress').val(),
            weight: parseFloat($('#weight').val()),
            volume: $('#volume').val() ? parseFloat($('#volume').val()) : null,
            freight: parseFloat($('#freight').val()),
            startStationId: parseInt($('#startStationId').val()),
            endStationId: parseInt($('#endStationId').val()),
            status: parseInt($('#status').val()) || 1,
            vehicleId: $('#vehicleId').val() ? parseInt($('#vehicleId').val()) : null,
            remark: $('#remark').val()
        };

        // 如果是编辑，添加orderId
        const orderId = $('#orderId').val();
        if (orderId) {
            formData.orderId = parseInt(orderId);
        }

        const url = orderId
            ? '${pageContext.request.contextPath}/api/orders/' + orderId
            : '${pageContext.request.contextPath}/api/orders';
        const method = orderId ? 'PUT' : 'POST';

        Utils.showLoading('正在提交...');

        $.ajax({
            url: url,
            type: method,
            contentType: 'application/json',
            data: JSON.stringify(formData),
            success: function(response) {
                Utils.hideLoading();
                if (response.code === 200) {
                    Utils.showSuccess(method === 'POST' ? '订单创建成功！' : '订单更新成功！');

                    // 显示成功信息，3秒后跳转
                    setTimeout(function() {
                        window.location.href = '${pageContext.request.contextPath}/orders';
                    }, 2000);
                } else {
                    Utils.showError(response.message || '操作失败');

                    // 处理特定的错误
                    if (response.message && response.message.includes('订单号')) {
                        $('#orderNumber').addClass('is-invalid');
                        $('#orderNumber').next('.invalid-feedback').text(response.message).show();
                        $('#orderNumber').focus();
                    }
                }
            },
            error: function(xhr) {
                Utils.hideLoading();

                let errorMessage = '请求失败，请检查网络连接';
                if (xhr.status === 403) {
                    errorMessage = '权限不足，无法执行此操作';
                } else if (xhr.responseJSON && xhr.responseJSON.message) {
                    errorMessage = xhr.responseJSON.message;
                }

                Utils.showError(errorMessage);
            }
        });
    }

    // 重置提交按钮状态
    function resetSubmitButton() {
        $('#submitBtnText').removeClass('d-none');
        $('#submitLoading').addClass('d-none');
        $('button[onclick="submitForm()"]').prop('disabled', false);
    }

    // 显示提示信息
    function showAlert(type, message) {
        if (type === 'error') {
            $('#errorAlert').removeClass('d-none').text(message);
        } else if (type === 'success') {
            $('#successAlert').removeClass('d-none').text(message);
        }

        // 滚动到顶部
        $('html, body').animate({ scrollTop: 0 }, 500);
    }
</script>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header">
        <h5 class="mb-0">${empty cargoItem ? '新增货物' : '编辑货物'}</h5>
    </div>
    <div class="card-body">
        <div id="errorAlert" class="alert alert-danger d-none"></div>

        <div id="cargoForm">
            <c:if test="${not empty cargoItem}">
                <input type="hidden" id="cargoId" value="${cargoItem.cargoId}">
            </c:if>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="cargoName" class="form-label required">货物名称</label>
                        <input type="text" class="form-control" id="cargoName" name="cargoName"
                               value="${cargoItem.cargoName}" required maxlength="100">
                        <div class="invalid-feedback">请输入货物名称</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="cargoType" class="form-label required">货物类型</label>
                        <select class="form-select" id="cargoType" name="cargoType" required>
                            <option value="">请选择货物类型</option>
                            <option value="电子产品" ${cargoItem.cargoType == '电子产品' ? 'selected' : ''}>电子产品</option>
                            <option value="服装" ${cargoItem.cargoType == '服装' ? 'selected' : ''}>服装</option>
                            <option value="食品" ${cargoItem.cargoType == '食品' ? 'selected' : ''}>食品</option>
                            <option value="日用品" ${cargoItem.cargoType == '日用品' ? 'selected' : ''}>日用品</option>
                            <option value="家具" ${cargoItem.cargoType == '家具' ? 'selected' : ''}>家具</option>
                            <option value="其他" ${cargoItem.cargoType == '其他' ? 'selected' : ''}>其他</option>
                        </select>
                        <div class="invalid-feedback">请选择货物类型</div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="orderId" class="form-label required">所属订单</label>
                        <select class="form-select" id="orderId" name="orderId" required>
                            <option value="">请选择订单</option>
                            <c:if test="${not empty orders}">
                                <c:forEach items="${orders}" var="order">
                                    <option value="${order.orderId}"
                                        ${cargoItem.orderId == order.orderId ? 'selected' : ''}>
                                            ${order.orderNumber} - ${order.senderName}
                                    </option>
                                </c:forEach>
                            </c:if>
                        </select>
                        <div class="invalid-feedback">请选择所属订单</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="quantity" class="form-label required">数量</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="quantity" name="quantity"
                                   value="${cargoItem.quantity}" required min="1" step="1">
                            <select class="form-select" id="unit" name="unit" style="max-width: 100px;">
                                <option value="件" ${cargoItem.unit == '件' ? 'selected' : ''}>件</option>
                                <option value="箱" ${cargoItem.unit == '箱' ? 'selected' : ''}>箱</option>
                                <option value="袋" ${cargoItem.unit == '袋' ? 'selected' : ''}>袋</option>
                                <option value="个" ${cargoItem.unit == '个' ? 'selected' : ''}>个</option>
                                <option value="台" ${cargoItem.unit == '台' ? 'selected' : ''}>台</option>
                            </select>
                        </div>
                        <div class="invalid-feedback">请输入数量</div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="totalWeight" class="form-label required">重量(kg)</label>
                        <input type="number" class="form-control" id="totalWeight" name="totalWeight"
                               value="${cargoItem.totalWeight}" required min="0.1" step="0.01">
                        <div class="invalid-feedback">请输入重量</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="totalVolume" class="form-label">体积(m³)</label>
                        <input type="number" class="form-control" id="totalVolume" name="totalVolume"
                               value="${cargoItem.totalVolume}" min="0" step="0.001">
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="declaredValue" class="form-label required">价值(¥)</label>
                        <input type="number" class="form-control" id="declaredValue" name="declaredValue"
                               value="${cargoItem.declaredValue}" required min="0" step="0.01">
                        <div class="invalid-feedback">请输入价值</div>
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <label for="specialRequirements" class="form-label">特殊要求</label>
                <textarea class="form-control" id="specialRequirements" name="specialRequirements"
                          rows="3" maxlength="500">${cargoItem.specialRequirements}</textarea>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="status" class="form-label">状态</label>
                        <select class="form-select" id="status" name="status">
                            <option value="1" ${empty cargoItem or cargoItem.status == 1 ? 'selected' : ''}>正常</option>
                            <option value="2" ${cargoItem.status == 2 ? 'selected' : ''}>已破损</option>
                            <option value="3" ${cargoItem.status == 3 ? 'selected' : ''}>已丢失</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <a href="${pageContext.request.contextPath}/cargo_items" class="btn btn-secondary me-2">取消</a>
                <button type="button" class="btn btn-primary" onclick="submitCargoForm()">
                    <span id="submitBtnText">${empty cargoItem ? '创建货物' : '更新货物'}</span>
                    <span id="submitLoading" class="spinner-border spinner-border-sm d-none" role="status"></span>
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        console.log('货物表单页面加载完成');

        // 如果订单列表为空，加载订单
        <c:if test="${empty orders}">
        loadOrders();
        </c:if>
    });

    // 加载订单列表
    function loadOrders() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/orders/search',
            type: 'GET',
            data: { size: 100 },
            success: function(response) {
                if (response.code === 200 && response.data) {
                    updateOrderOptions(response.data.list);
                }
            }
        });
    }

    function updateOrderOptions(orders) {
        const $select = $('#orderId');
        $select.empty();
        $select.append('<option value="">请选择订单</option>');

        const currentOrderId = $('#cargoId').val() ? '${cargoItem.orderId}' : null;

        orders.forEach(function(order) {
            const selected = currentOrderId && order.orderId == currentOrderId ? 'selected' : '';
            $select.append(
                `<option value="${order.orderId}" ${selected}>${order.orderNumber} - ${order.senderName}</option>`
            );
        });
    }

    // 表单验证
    function validateCargoForm() {
        let isValid = true;
        $('.invalid-feedback').hide();
        $('.is-invalid').removeClass('is-invalid');

        // 修改字段名
        const requiredFields = ['cargoName', 'cargoType', 'orderId', 'quantity', 'totalWeight', 'declaredValue'];

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

        // 验证数字字段（修改字段名）
        const quantity = parseInt($('#quantity').val());
        if (isNaN(quantity) || quantity <= 0) {
            $('#quantity').addClass('is-invalid');
            $('#quantity').next('.invalid-feedback').text('请输入大于0的数量');
            isValid = false;
        }

        // 修改为 totalWeight
        const totalWeight = parseFloat($('#totalWeight').val());
        if (isNaN(totalWeight) || totalWeight <= 0) {
            $('#totalWeight').addClass('is-invalid');
            $('#totalWeight').next('.invalid-feedback').text('请输入大于0的重量');
            isValid = false;
        }

        // 修改为 declaredValue
        const declaredValue = parseFloat($('#declaredValue').val());
        if (isNaN(declaredValue) || declaredValue < 0) {
            $('#declaredValue').addClass('is-invalid');
            $('#declaredValue').next('.invalid-feedback').text('请输入有效的价值金额');
            isValid = false;
        }

        return isValid;
    }


    // 提交表单
    function submitCargoForm() {
        console.log('提交货物表单');

        if (!validateCargoForm()) {
            showAlert('error', '请填写完整的表单信息');
            return;
        }

        // 显示加载状态
        $('#submitBtnText').addClass('d-none');
        $('#submitLoading').removeClass('d-none');
        $('button[onclick="submitCargoForm()"]').prop('disabled', true);

        // 收集表单数据（修改字段名）
        const formData = {
            cargoName: $('#cargoName').val().trim(),
            cargoType: $('#cargoType').val().trim(),
            orderId: parseInt($('#orderId').val()),
            quantity: parseInt($('#quantity').val()),
            unit: $('#unit').val(),
            totalWeight: parseFloat($('#totalWeight').val()),  // 修改
            totalVolume: $('#totalVolume').val() ? parseFloat($('#totalVolume').val()) : null,  // 修改
            declaredValue: parseFloat($('#declaredValue').val()),  // 修改
            specialRequirements: $('#specialRequirements').val().trim() || null,
            status: parseInt($('#status').val()) || 1
        };

        // 如果是编辑，添加cargoId
        const cargoId = $('#cargoId').val();
        if (cargoId) {
            formData.cargoId = parseInt(cargoId);
        }

        const url = cargoId
            ? '${pageContext.request.contextPath}/api/cargo_items/' + cargoId
            : '${pageContext.request.contextPath}/api/cargo_items';
        const method = cargoId ? 'PUT' : 'POST';

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
                    Utils.showSuccess(method === 'POST' ? '货物创建成功！' : '货物更新成功！');

                    setTimeout(function() {
                        window.location.href = '${pageContext.request.contextPath}/cargo_items';
                    }, 1500);
                } else {
                    Utils.showError(response.message || '操作失败');
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
        $('button[onclick="submitCargoForm()"]').prop('disabled', false);
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

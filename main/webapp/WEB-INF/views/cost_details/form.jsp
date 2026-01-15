<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="card">
    <div class="card-header">
        <h5 class="mb-0">${empty costDetail ? '新增费用' : '编辑费用'}</h5>
    </div>
    <div class="card-body">
        <div id="errorAlert" class="alert alert-danger d-none"></div>

        <div id="costForm">
            <c:if test="${not empty costDetail}">
                <input type="hidden" id="costId" value="${costDetail.costId}">
            </c:if>


            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="orderId" class="form-label required">所属订单</label>
                        <select class="form-select" id="orderId" name="orderId" required>
                            <option value="">请选择订单</option>
                            <c:if test="${not empty orders}">
                                <c:forEach items="${orders}" var="order">
                                    <option value="${order.orderId}"
                                        ${costDetail.orderId == order.orderId ? 'selected' : ''}>
                                            ${order.orderNumber} - ${order.senderName} (运费:¥${order.freight})
                                    </option>
                                </c:forEach>
                            </c:if>
                        </select>
                        <div class="invalid-feedback">请选择所属订单</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="costType" class="form-label required">费用类型</label>
                        <select class="form-select" id="costType" name="costType" required>
                            <option value="">请选择费用类型</option>
                            <option value="1" ${costDetail.costType == 1 ? 'selected' : ''}>运费</option>
                            <option value="2" ${costDetail.costType == 2 ? 'selected' : ''}>包装费</option>
                            <option value="3" ${costDetail.costType == 3 ? 'selected' : ''}>保险费</option>
                            <option value="4" ${costDetail.costType == 4 ? 'selected' : ''}>仓储费</option>
                            <option value="5" ${costDetail.costType == 5 ? 'selected' : ''}>装卸费</option>
                            <option value="6" ${costDetail.costType == 6 ? 'selected' : ''}>其他</option>
                        </select>
                        <div class="invalid-feedback">请选择费用类型</div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="costCategory" class="form-label required">费用分类</label>
                        <select class="form-select" id="costCategory" name="costCategory" required>
                            <option value="">请选择费用分类</option>
                            <option value="1" ${costDetail.costCategory == 1 ? 'selected' : ''}>运输费用</option>
                            <option value="2" ${costDetail.costCategory == 2 ? 'selected' : ''}>包装费用</option>
                            <option value="3" ${costDetail.costCategory == 3 ? 'selected' : ''}>保险费用</option>
                            <option value="4" ${costDetail.costCategory == 4 ? 'selected' : ''}>仓储费用</option>
                            <option value="5" ${costDetail.costCategory == 5 ? 'selected' : ''}>管理费</option>
                            <option value="6" ${costDetail.costCategory == 6 ? 'selected' : ''}>其他费用</option>
                        </select>
                        <div class="invalid-feedback">请选择费用分类</div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="amount" class="form-label required">费用金额</label>
                        <input type="number" class="form-control" id="amount" name="amount"
                               value="${costDetail.amount}" required min="0" step="0.01">
                        <div class="invalid-feedback">请输入费用金额</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="currency" class="form-label required">货币</label>
                        <select class="form-select" id="currency" name="currency" required>
                            <option value="CNY" ${costDetail.currency == 'CNY' or empty costDetail ? 'selected' : ''}>人民币 (CNY)</option>
                            <option value="USD" ${costDetail.currency == 'USD' ? 'selected' : ''}>美元 (USD)</option>
                            <option value="EUR" ${costDetail.currency == 'EUR' ? 'selected' : ''}>欧元 (EUR)</option>
                            <option value="JPY" ${costDetail.currency == 'JPY' ? 'selected' : ''}>日元 (JPY)</option>
                        </select>
                        <div class="invalid-feedback">请选择货币</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="paymentStatus" class="form-label">支付状态</label>
                        <select class="form-select" id="paymentStatus" name="paymentStatus">
                            <option value="1" ${empty costDetail or costDetail.paymentStatus == 1 ? 'selected' : ''}>未支付</option>
                            <option value="2" ${costDetail.paymentStatus == 2 ? 'selected' : ''}>已支付</option>
                            <option value="3" ${costDetail.paymentStatus == 3 ? 'selected' : ''}>已取消</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="paymentMethod" class="form-label">支付方式</label>
                        <select class="form-select" id="paymentMethod" name="paymentMethod">
                            <option value="">请选择支付方式</option>
                            <option value="现金" ${costDetail.paymentMethod == '现金' ? 'selected' : ''}>现金</option>
                            <option value="银行卡" ${costDetail.paymentMethod == '银行卡' ? 'selected' : ''}>银行卡</option>
                            <option value="在线支付" ${costDetail.paymentMethod == '在线支付' ? 'selected' : ''}>在线支付</option>
                            <option value="微信" ${costDetail.paymentMethod == '微信' ? 'selected' : ''}>微信</option>
                            <option value="支付宝" ${costDetail.paymentMethod == '支付宝' ? 'selected' : ''}>支付宝</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="paymentTime" class="form-label">支付时间</label>
                        <input type="datetime-local" class="form-control" id="paymentTime" name="paymentTime"
                               value="${costDetail.paymentTime}">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="costDescription" class="form-label required">费用说明</label>
                        <textarea class="form-control" id="costDescription" name="costDescription"
                                  rows="3" required maxlength="500">${costDetail.costDescription}</textarea>
                        <div class="invalid-feedback">请输入费用说明</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="costTime" class="form-label required">费用时间</label>
                        <input type="datetime-local" class="form-control" id="costTime" name="costTime"
                               required>
                        <div class="invalid-feedback">请选择费用时间</div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="payerId" class="form-label">付款方</label>
                        <select class="form-select" id="payerId" name="payerId">
                            <option value="">请选择付款方</option>
                            <c:if test="${not empty users}">
                                <c:forEach items="${users}" var="user">
                                    <option value="${user.userId}"
                                        ${costDetail.payerId == user.userId ? 'selected' : ''}>
                                            ${user.username} (${user.userType})
                                    </option>
                                </c:forEach>
                            </c:if>
                        </select>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="payeeId" class="form-label">收款方</label>
                        <select class="form-select" id="payeeId" name="payeeId">
                            <option value="">请选择收款方</option>
                            <c:if test="${not empty users}">
                                <c:forEach items="${users}" var="user">
                                    <option value="${user.userId}"
                                        ${costDetail.payeeId == user.userId ? 'selected' : ''}>
                                            ${user.username} (${user.userType})
                                    </option>
                                </c:forEach>
                            </c:if>
                        </select>
                    </div>
                </div>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <a href="${pageContext.request.contextPath}/cost_details" class="btn btn-secondary me-2">取消</a>
                <button type="button" class="btn btn-primary" onclick="submitCostForm()">
                    <span id="submitBtnText">${empty costDetail ? '创建费用' : '更新费用'}</span>
                    <span id="submitLoading" class="spinner-border spinner-border-sm d-none" role="status"></span>
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // 如果有时间值，格式化后设置
        <c:if test="${not empty costDetail.costTime}">
        const costTime = new Date('${costDetail.costTime}');
        const formattedCostTime = costTime.toISOString().slice(0, 16);
        $('#costTime').val(formattedCostTime);
        </c:if>

        // 新增时设置默认时间
        <c:if test="${empty costDetail}">
        const now = new Date();
        const localDateTime = new Date(now.getTime() - now.getTimezoneOffset() * 60000)
            .toISOString()
            .slice(0, 16);
        $('#costTime').val(localDateTime);
        </c:if>
    });

    $(document).ready(function() {
        console.log('费用表单页面加载完成');

        // 如果订单列表为空，加载订单
        <c:if test="${empty orders}">
        loadOrders();
        </c:if>

        // 如果用户列表为空，加载用户
        <c:if test="${empty users}">
        loadUsers();
        </c:if>

        // 如果选择已支付，显示支付方式和支付时间
        $('#paymentStatus').on('change', function() {
            const status = $(this).val();
            if (status == '2') {
                $('#paymentMethod').prop('required', true);
                $('#paymentTime').prop('required', true);
                $('#paymentMethod').closest('.mb-3').show();
                $('#paymentTime').closest('.mb-3').show();
            } else {
                $('#paymentMethod').prop('required', false);
                $('#paymentTime').prop('required', false);
            }
        });

        // 初始化显示/隐藏
        if ($('#paymentStatus').val() != '2') {
            $('#paymentMethod').closest('.mb-3').show();
            $('#paymentTime').closest('.mb-3').show();
        }
    });

    // 加载订单列表
    function loadOrders() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/orders/search',
            type: 'GET',
            data: { size: 100, status: '1,2,3' },
            success: function(response) {
                if (response.code === 200 && response.data) {
                    updateOrderOptions(response.data.list);
                }
            }
        });
    }

    // 加载用户列表
    function loadUsers() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/users',
            type: 'GET',
            data: { size: 100 },
            success: function(response) {
                if (response.code === 200 && response.data) {
                    updateUserOptions(response.data.list, 'payerId');
                    updateUserOptions(response.data.list, 'payeeId');
                }
            }
        });
    }

    function updateOrderOptions(orders) {
        const $select = $('#orderId');
        $select.empty();
        $select.append('<option value="">请选择订单</option>');

        const currentOrderId = $('#costId').val() ? '${costDetail.orderId}' : null;

        orders.forEach(function(order) {
            const selected = currentOrderId && order.orderId == currentOrderId ? 'selected' : '';
            $select.append(
                `<option value="${order.orderId}" ${selected}>
                    ${order.orderNumber} - ${order.senderName} (运费:¥${order.freight})
                </option>`
            );
        });
    }

    function updateUserOptions(users, selectId) {
        const $select = $('#' + selectId);
        $select.empty();
        $select.append('<option value="">请选择用户</option>');

        const currentUserId = $('#costId').val() ? (selectId === 'payerId' ? '${costDetail.payerId}' : '${costDetail.payeeId}') : null;

        users.forEach(function(user) {
            const selected = currentUserId && user.userId == currentUserId ? 'selected' : '';
            $select.append(
                `<option value="${user.userId}" ${selected}>
                    ${user.username} (${user.userType})
                </option>`
            );
        });
    }

    // 表单验证
    function validateCostForm() {
        let isValid = true;
        $('.invalid-feedback').hide();
        $('.is-invalid').removeClass('is-invalid');

        // 添加 costCategory 到必填字段列表
        const requiredFields = ['orderId', 'costType', 'costCategory', 'amount', 'currency', 'costDescription', 'costTime'];

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

        // 验证金额
        const amount = parseFloat($('#amount').val());
        if (isNaN(amount) || amount < 0) {
            $('#amount').addClass('is-invalid');
            $('#amount').next('.invalid-feedback').text('请输入有效的金额');
            isValid = false;
        }

        // 如果选择已支付，验证支付方式和时间
        const status = $('#paymentStatus').val();
        if (status === '2') {
            const paymentMethod = $('#paymentMethod').val();
            if (!paymentMethod) {
                $('#paymentMethod').addClass('is-invalid');
                $('#paymentMethod').next('.invalid-feedback').text('请选择支付方式');
                isValid = false;
            }
        }

        return isValid;
    }

    // 提交表单
    function submitCostForm() {
        console.log('提交费用表单');

        if (!validateCostForm()) {
            showAlert('error', '请填写完整的表单信息');
            return;
        }

        // 显示加载状态
        $('#submitBtnText').addClass('d-none');
        $('#submitLoading').removeClass('d-none');
        $('button[onclick="submitCostForm()"]').prop('disabled', true);

        // 收集表单数据 - 添加 costCategory
        const formData = {
            orderId: parseInt($('#orderId').val()),
            costType: $('#costType').val(),
            costCategory: $('#costCategory').val(), // 添加这一行
            amount: parseFloat($('#amount').val()),
            currency: $('#currency').val(),
            costDescription: $('#costDescription').val().trim(),
            costTime: $('#costTime').val(),
            paymentStatus: parseInt($('#paymentStatus').val()) || 1
        };

        // 可选字段
        const paymentMethod = $('#paymentMethod').val();
        if (paymentMethod) {
            formData.paymentMethod = paymentMethod;
        }

        const paymentTime = $('#paymentTime').val();
        if (paymentTime) {
            formData.paymentTime = paymentTime;
        }

        const payerId = $('#payerId').val();
        if (payerId) {
            formData.payerId = parseInt(payerId);
        }

        const payeeId = $('#payeeId').val();
        if (payeeId) {
            formData.payeeId = parseInt(payeeId);
        }

        // 如果是编辑，添加costId
        const costId = $('#costId').val();
        if (costId) {
            formData.costId = parseInt(costId);
        }

        console.log('提交的数据:', formData); // 添加日志查看数据

        const url = costId
            ? '${pageContext.request.contextPath}/api/cost_details/' + costId
            : '${pageContext.request.contextPath}/api/cost_details';
        const method = costId ? 'PUT' : 'POST';

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
                    Utils.showSuccess(method === 'POST' ? '费用创建成功！' : '费用更新成功！');

                    setTimeout(function() {
                        window.location.href = '${pageContext.request.contextPath}/cost_details';
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
                console.error('提交错误:', xhr.responseJSON); // 添加错误日志
            }
        });
    }

    function resetSubmitButton() {
        $('#submitBtnText').removeClass('d-none');
        $('#submitLoading').addClass('d-none');
        $('button[onclick="submitCostForm()"]').prop('disabled', false);
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
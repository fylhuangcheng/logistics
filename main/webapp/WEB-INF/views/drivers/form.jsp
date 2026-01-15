<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header">
        <h5 class="mb-0">${empty driver ? '新增司机' : '编辑司机'}</h5>
    </div>
    <div class="card-body">
        <div id="errorAlert" class="alert alert-danger d-none"></div>

        <div id="driverForm">
            <c:if test="${not empty driver}">
                <input type="hidden" id="driverId" value="${driver.driverId}">
            </c:if>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="userId" class="form-label required">关联用户</label>
                        <select class="form-select" id="userId" name="userId" required>
                            <option value="">请选择关联用户</option>
                            <c:if test="${not empty users}">
                                <c:forEach items="${users}" var="user">
                                    <option value="${user.userId}"
                                        ${driver.userId == user.userId ? 'selected' : ''}>
                                            ${user.username} (${user.realName})
                                    </option>
                                </c:forEach>
                            </c:if>
                        </select>
                        <div class="invalid-feedback">请选择关联用户</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="licenseNumber" class="form-label required">驾照号码</label>
                        <input type="text" class="form-control" id="licenseNumber" name="licenseNumber"
                               value="${driver.licenseNumber}" required maxlength="20">
                        <div class="invalid-feedback">请输入驾照号码</div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="licenseType" class="form-label required">驾照类型</label>
                        <input type="text" class="form-control" id="licenseType" name="licenseType"
                               value="${driver.licenseType}" required maxlength="50">
                        <div class="invalid-feedback">请输入驾照类型</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="licenseExpiryDate" class="form-label required">驾照到期日期</label>
                        <input type="date" class="form-control" id="licenseExpiryDate" name="licenseExpiryDate"
                               value="${driver.licenseExpiryDate}" required>
                        <div class="invalid-feedback">请选择驾照到期日期</div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="yearsExperience" class="form-label">驾龄(年)</label>
                        <input type="number" class="form-control" id="yearsExperience" name="yearsExperience"
                               value="${driver.yearsExperience}" min="0" max="50">
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="totalMileage" class="form-label">总里程(km)</label>
                        <input type="number" class="form-control" id="totalMileage" name="totalMileage"
                               value="${driver.totalMileage}" min="0" step="0.1">
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="mb-3">
                        <label for="safetyScore" class="form-label">安全评分</label>
                        <input type="number" class="form-control" id="safetyScore" name="safetyScore"
                               value="${driver.safetyScore}" min="0" max="100" step="0.1">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="emergencyContact" class="form-label">紧急联系人</label>
                        <input type="text" class="form-control" id="emergencyContact" name="emergencyContact"
                               value="${driver.emergencyContact}" maxlength="50">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="emergencyPhone" class="form-label">紧急联系电话</label>
                        <input type="tel" class="form-control" id="emergencyPhone" name="emergencyPhone"
                               value="${driver.emergencyPhone}" maxlength="20">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="healthStatus" class="form-label">健康状况</label>
                        <select class="form-select" id="healthStatus" name="healthStatus">
                            <option value="">请选择健康状况</option>
                            <option value="良好" ${driver.healthStatus == '良好' ? 'selected' : ''}>良好</option>
                            <option value="一般" ${driver.healthStatus == '一般' ? 'selected' : ''}>一般</option>
                            <option value="有病史" ${driver.healthStatus == '有病史' ? 'selected' : ''}>有病史</option>
                            <option value="需关注" ${driver.healthStatus == '需关注' ? 'selected' : ''}>需关注</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="assignedVehicleId" class="form-label">分配车辆</label>
                        <select class="form-select" id="assignedVehicleId" name="assignedVehicleId">
                            <option value="">请选择分配车辆</option>
                            <c:if test="${not empty vehicles}">
                                <c:forEach items="${vehicles}" var="vehicle">
                                    <option value="${vehicle.vehicleId}"
                                        ${driver.assignedVehicleId == vehicle.vehicleId ? 'selected' : ''}>
                                            ${vehicle.licensePlate} (${vehicle.vehicleType})
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
                        <label for="lastRestTime" class="form-label">上次休息时间</label>
                        <input type="datetime-local" class="form-control" id="lastRestTime" name="lastRestTime"
                               value="${driver.lastRestTime}">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="currentStatus" class="form-label">当前状态</label>
                        <select class="form-select" id="currentStatus" name="currentStatus">
                            <option value="1" ${empty driver or driver.currentStatus == 1 ? 'selected' : ''}>空闲</option>
                            <option value="2" ${driver.currentStatus == 2 ? 'selected' : ''}>运输中</option>
                            <option value="3" ${driver.currentStatus == 3 ? 'selected' : ''}>休假</option>
                            <option value="4" ${driver.currentStatus == 4 ? 'selected' : ''}>离职</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <a href="${pageContext.request.contextPath}/drivers" class="btn btn-secondary me-2">取消</a>
                <button type="button" class="btn btn-primary" onclick="submitDriverForm()">
                    <span id="submitBtnText">${empty driver ? '创建司机' : '更新司机'}</span>
                    <span id="submitLoading" class="spinner-border spinner-border-sm d-none" role="status"></span>
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        console.log('司机表单页面加载完成');

        // 如果用户列表为空，加载用户
        <c:if test="${empty users}">
        loadUsers();
        </c:if>

        // 如果车辆列表为空，加载车辆
        <c:if test="${empty vehicles}">
        loadVehicles();
        </c:if>

        // 实时检查驾照号码是否重复
        $('#licenseNumber').on('blur', function() {
            const licenseNumber = $(this).val().trim();
            if (!licenseNumber || $('#driverId').val()) return;

            $.ajax({
                url: '${pageContext.request.contextPath}/api/drivers/license/' + encodeURIComponent(licenseNumber),
                type: 'GET',
                success: function(response) {
                    if (response.code === 200 && response.data) {
                        $(this).addClass('is-invalid');
                        $(this).next('.invalid-feedback').text('驾照号码已存在');
                    } else {
                        $(this).removeClass('is-invalid');
                    }
                }.bind(this)
            });
        });
    });

    // 加载用户列表
    function loadUsers() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/users/search',
            type: 'GET',
            data: { role: 'driver', size: 100 },
            success: function(response) {
                if (response.code === 200 && response.data) {
                    updateUserOptions(response.data.list);
                }
            }
        });
    }

    // 加载车辆列表
    function loadVehicles() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/vehicles/search',
            type: 'GET',
            data: { status: '1', size: 100 }, // 空闲的车辆
            success: function(response) {
                if (response.code === 200 && response.data) {
                    updateVehicleOptions(response.data.list);
                }
            }
        });
    }

    function updateUserOptions(users) {
        const $select = $('#userId');
        $select.empty();
        $select.append('<option value="">请选择关联用户</option>');

        const currentUserId = $('#driverId').val() ? '${driver.userId}' : null;

        users.forEach(function(user) {
            const selected = currentUserId && user.userId == currentUserId ? 'selected' : '';
            $select.append(
                `<option value="${user.userId}" ${selected}>${user.username} (${user.realName})</option>`
            );
        });
    }

    function updateVehicleOptions(vehicles) {
        const $select = $('#assignedVehicleId');
        $select.empty();
        $select.append('<option value="">请选择分配车辆</option>');

        const currentVehicleId = $('#driverId').val() ? '${driver.assignedVehicleId}' : null;

        vehicles.forEach(function(vehicle) {
            const selected = currentVehicleId && vehicle.vehicleId == currentVehicleId ? 'selected' : '';
            $select.append(
                `<option value="${vehicle.vehicleId}" ${selected}>${vehicle.licensePlate} (${vehicle.vehicleType})</option>`
            );
        });
    }

    // 表单验证
    function validateDriverForm() {
        let isValid = true;
        $('.invalid-feedback').hide();
        $('.is-invalid').removeClass('is-invalid');

        const requiredFields = ['userId', 'licenseNumber', 'licenseType'];

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

        // 验证驾龄
        const yearsExperience = parseInt($('#yearsExperience').val());
        if (!isNaN(yearsExperience) && (yearsExperience < 0 || yearsExperience > 50)) {
            $('#yearsExperience').addClass('is-invalid');
            isValid = false;
        }

        // 验证安全评分
        const safetyScore = parseFloat($('#safetyScore').val());
        if (!isNaN(safetyScore) && (safetyScore < 0 || safetyScore > 100)) {
            $('#safetyScore').addClass('is-invalid');
            isValid = false;
        }

        return isValid;
    }

    // 提交表单
    function submitDriverForm() {
        console.log('提交司机表单');

        if (!validateDriverForm()) {
            showAlert('error', '请填写完整的表单信息');
            return;
        }

        // 显示加载状态
        $('#submitBtnText').addClass('d-none');
        $('#submitLoading').removeClass('d-none');
        $('button[onclick="submitDriverForm()"]').prop('disabled', true);

        // 收集表单数据
        const formData = {
            userId: parseInt($('#userId').val()),
            licenseNumber: $('#licenseNumber').val().trim(),
            licenseType: $('#licenseType').val().trim(),
            currentStatus: parseInt($('#currentStatus').val()) || 1
        };

        // 可选字段
        const licenseExpiryDate = $('#licenseExpiryDate').val();
        if (licenseExpiryDate) {
            formData.licenseExpiryDate = licenseExpiryDate;
        }

        const yearsExperience = $('#yearsExperience').val();
        if (yearsExperience) {
            formData.yearsExperience = parseInt(yearsExperience);
        }

        const totalMileage = $('#totalMileage').val();
        if (totalMileage) {
            formData.totalMileage = parseFloat(totalMileage);
        }

        const safetyScore = $('#safetyScore').val();
        if (safetyScore) {
            formData.safetyScore = parseFloat(safetyScore);
        }

        const emergencyContact = $('#emergencyContact').val().trim();
        if (emergencyContact) {
            formData.emergencyContact = emergencyContact;
        }

        const emergencyPhone = $('#emergencyPhone').val().trim();
        if (emergencyPhone) {
            formData.emergencyPhone = emergencyPhone;
        }

        const healthStatus = $('#healthStatus').val();
        if (healthStatus) {
            formData.healthStatus = healthStatus;
        }

        const assignedVehicleId = $('#assignedVehicleId').val();
        if (assignedVehicleId) {
            formData.assignedVehicleId = parseInt(assignedVehicleId);
        }

        const lastRestTime = $('#lastRestTime').val();
        if (lastRestTime) {
            formData.lastRestTime = lastRestTime;
        }

        // 如果是编辑，添加driverId
        const driverId = $('#driverId').val();
        if (driverId) {
            formData.driverId = parseInt(driverId);
        }

        const url = driverId
            ? '${pageContext.request.contextPath}/api/drivers/' + driverId
            : '${pageContext.request.contextPath}/api/drivers';
        const method = driverId ? 'PUT' : 'POST';

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
                    Utils.showSuccess(method === 'POST' ? '司机创建成功！' : '司机更新成功！');

                    setTimeout(function() {
                        window.location.href = '${pageContext.request.contextPath}/drivers';
                    }, 1500);
                } else {
                    Utils.showError(response.message || '操作失败');

                    // 如果是驾照号码重复的错误，高亮显示
                    if (response.message && response.message.includes('驾照号码')) {
                        $('#licenseNumber').addClass('is-invalid');
                        $('#licenseNumber').next('.invalid-feedback').text(response.message).show();
                        $('#licenseNumber').focus();
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
        $('button[onclick="submitDriverForm()"]').prop('disabled', false);
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
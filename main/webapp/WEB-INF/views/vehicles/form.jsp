<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header">
        <h5 class="mb-0">${empty vehicle ? '新增车辆' : '编辑车辆'}</h5>
    </div>
    <div class="card-body">
        <!-- 错误提示 -->
        <c:if test="${not empty result and result.code != 200}">
            <div class="alert alert-danger">${result.message}</div>
        </c:if>

        <form id="vehicleForm" class="needs-validation" novalidate>
            <c:if test="${not empty vehicle}">
                <input type="hidden" name="vehicleId" value="${vehicle.vehicleId}">
            </c:if>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="licensePlate" class="form-label required">车牌号</label>
                    <input type="text" class="form-control" id="licensePlate" name="licensePlate"
                           value="${vehicle.licensePlate}" required maxlength="20">
                    <div class="invalid-feedback">请输入车牌号</div>
                </div>

                <div class="col-md-6 mb-3">
                    <label for="vehicleType" class="form-label required">车辆类型</label>
                    <select class="form-select" id="vehicleType" name="vehicleType" required>
                        <option value="">请选择车辆类型</option>
                        <option value="重型货车" ${vehicle.vehicleType == '重型货车' ? 'selected' : ''}>重型货车</option>
                        <option value="中型货车" ${vehicle.vehicleType == '中型货车' ? 'selected' : ''}>中型货车</option>
                        <option value="厢式货车" ${vehicle.vehicleType == '厢式货车' ? 'selected' : ''}>厢式货车</option>
                        <option value="冷藏车" ${vehicle.vehicleType == '冷藏车' ? 'selected' : ''}>冷藏车</option>
                    </select>
                    <div class="invalid-feedback">请选择车辆类型</div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="loadCapacity" class="form-label required">载重量(吨)</label>
                    <input type="number" class="form-control" id="loadCapacity" name="loadCapacity"
                           value="${vehicle.loadCapacity}" required min="0" step="0.01">
                    <div class="invalid-feedback">请输入载重量</div>
                </div>

                <div class="col-md-6 mb-3">
                    <label for="status" class="form-label">状态</label>
                    <select class="form-select" id="status" name="status">
                        <option value="1" ${empty vehicle or vehicle.status == 1 ? 'selected' : ''}>空闲</option>
                        <option value="2" ${vehicle.status == 2 ? 'selected' : ''}>运输中</option>
                        <option value="3" ${vehicle.status == 3 ? 'selected' : ''}>维修中</option>
                    </select>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="currentStationId" class="form-label">当前位置</label>
                    <select class="form-select" id="currentStationId" name="currentStationId">
                        <option value="">请选择网点</option>
                        <c:if test="${not empty stations}">
                            <c:forEach items="${stations}" var="station">
                                <option value="${station.stationId}"
                                    ${vehicle.currentStationId == station.stationId ? 'selected' : ''}>
                                        ${station.stationName}
                                </option>
                            </c:forEach>
                        </c:if>
                    </select>
                    <div class="form-text">
                        <c:choose>
                            <c:when test="${not empty stations}">
                                已加载 ${stations.size()} 个网点
                            </c:when>
                            <c:otherwise>
                                正在加载网点列表...
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-md-6 mb-3">
                    <label for="driverName" class="form-label">驾驶员</label>
                    <input type="text" class="form-control" id="driverName" name="driverName"
                           value="${vehicle.driverName}" maxlength="50">
                </div>
            </div>

            <div class="mb-3">
                <label for="driverPhone" class="form-label">驾驶员电话</label>
                <input type="tel" class="form-control" id="driverPhone" name="driverPhone"
                       value="${vehicle.driverPhone}" maxlength="20">
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-secondary me-2">取消</a>
                <button type="button" class="btn btn-primary" onclick="submitForm()">
                    ${empty vehicle ? '创建' : '更新'}
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    $(document).ready(function() {
        // 如果stations为空，通过AJAX动态加载
        <c:if test="${empty stations}">
        loadStations();
        </c:if>

        // 实时检查车牌号是否重复
        $('#licensePlate').on('blur', function() {
            const licensePlate = $(this).val();
            if (licensePlate.trim() === '') return;

            $.ajax({
                url: '${pageContext.request.contextPath}/api/vehicles/license/' + encodeURIComponent(licensePlate),
                type: 'GET',
                success: function(response) {
                    if (response.code === 200 && response.data) {
                        $('#licensePlate').addClass('is-invalid');
                        $('#licensePlate').next('.invalid-feedback').text('车牌号已存在');
                    } else {
                        $('#licensePlate').removeClass('is-invalid');
                    }
                }
            });
        });
    });

    function loadStations() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/stations/active',
            type: 'GET',
            success: function(response) {
                if (response.code === 200 && response.data) {
                    var select = $('#currentStationId');
                    var currentStationId = ${not empty vehicle.currentStationId ? vehicle.currentStationId : 'null'};

                    // 清空已有选项（除了第一个）
                    select.find('option:not(:first)').remove();

                    // 添加新选项
                    response.data.forEach(function(station) {
                        var selected = (currentStationId !== null && station.stationId == currentStationId) ? 'selected' : '';
                        select.append('<option value="' + station.stationId + '" ' + selected + '>' +
                            station.stationName + ' (' + station.stationCode + ')</option>');
                    });

                    select.next('.form-text').html('已加载 ' + response.data.length + ' 个网点');
                } else {
                    showStationLoadError();
                }
            },
            error: function() {
                showStationLoadError();
            }
        });
    }

    function showStationLoadError() {
        $('#currentStationId').next('.form-text')
            .html('<span class="text-danger">加载网点列表失败，请刷新页面重试</span>');
    }

    // 优化后的表单提交
    function submitForm() {
        const form = document.getElementById('vehicleForm');
        if (!Utils.validateForm(form)) {
            return;
        }

        // 验证车牌号
        const licensePlate = $('#licensePlate').val().trim();
        if (!licensePlate) {
            $('#licensePlate').addClass('is-invalid');
            $('#licensePlate').next('.invalid-feedback').text('请输入车牌号');
            $('#licensePlate').focus();
            return;
        }

        // 验证车辆类型
        const vehicleType = $('#vehicleType').val();
        if (!vehicleType) {
            $('#vehicleType').addClass('is-invalid');
            $('#vehicleType').focus();
            return;
        }

        // 验证载重量
        const loadCapacity = parseFloat($('#loadCapacity').val());
        if (isNaN(loadCapacity) || loadCapacity <= 0) {
            $('#loadCapacity').addClass('is-invalid');
            $('#loadCapacity').focus();
            return;
        }

        // 构建表单数据
        const formData = {
            licensePlate: licensePlate,
            vehicleType: vehicleType,
            loadCapacity: loadCapacity,
            status: parseInt($('#status').val())
        };

        // 可选字段
        const currentStationId = $('#currentStationId').val();
        if (currentStationId) {
            formData.currentStationId = parseInt(currentStationId);
        }

        const driverName = $('#driverName').val().trim();
        if (driverName) {
            formData.driverName = driverName;
        }

        const driverPhone = $('#driverPhone').val().trim();
        if (driverPhone) {
            formData.driverPhone = driverPhone;
        }

        // 如果是编辑，添加vehicleId
        const vehicleId = $('input[name="vehicleId"]').val();
        if (vehicleId) {
            formData.vehicleId = parseInt(vehicleId);
        }

        const url = vehicleId
            ? '${pageContext.request.contextPath}/api/vehicles/' + vehicleId
            : '${pageContext.request.contextPath}/api/vehicles';
        const method = vehicleId ? 'PUT' : 'POST';

        Utils.showLoading('正在保存...');

        // 先检查车牌号是否重复（对于新建操作）
        if (!vehicleId) {
            checkLicensePlateUnique(licensePlate, function(isUnique) {
                if (!isUnique) {
                    Utils.hideLoading();
                    $('#licensePlate').addClass('is-invalid');
                    $('#licensePlate').next('.invalid-feedback').text('车牌号已存在');
                    $('#licensePlate').focus();
                    return;
                }
                submitVehicleData(url, method, formData);
            });
        } else {
            submitVehicleData(url, method, formData);
        }
    }

    function checkLicensePlateUnique(licensePlate, callback) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/vehicles/license/' + encodeURIComponent(licensePlate),
            type: 'GET',
            success: function(response) {
                callback(response.code !== 200 || !response.data);
            },
            error: function() {
                callback(true); // 如果检查失败，默认允许提交
            }
        });
    }

    function submitVehicleData(url, method, formData) {
        $.ajax({
            url: url,
            type: method,
            contentType: 'application/json',
            data: JSON.stringify(formData),
            success: function(response) {
                Utils.hideLoading();
                if (response.code === 200) {
                    Utils.showSuccess(response.message || '操作成功');

                    // 延迟跳转，让用户看到成功消息
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/vehicles';
                    }, 1500);
                } else {
                    Utils.showError(response.message || '操作失败');

                    // 处理特定的错误
                    if (response.message && response.message.includes('车牌号')) {
                        $('#licensePlate').addClass('is-invalid');
                        $('#licensePlate').next('.invalid-feedback').text(response.message);
                        $('#licensePlate').focus();
                    }
                }
            },
            error: function(xhr) {
                Utils.hideLoading();

                let errorMsg = '请求失败';
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    errorMsg = xhr.responseJSON.message;
                }

                Utils.showError(errorMsg);
            }
        });
    }

    // 实时车牌号检查优化
    $('#licensePlate').on('blur', function() {
        const licensePlate = $(this).val().trim();
        if (!licensePlate || $('input[name="vehicleId"]').val()) return;

        $.ajax({
            url: '${pageContext.request.contextPath}/api/vehicles/license/' + encodeURIComponent(licensePlate),
            type: 'GET',
            success: function(response) {
                if (response.code === 200 && response.data) {
                    $(this).addClass('is-invalid');
                    $(this).next('.invalid-feedback').text('车牌号已存在');
                } else {
                    $(this).removeClass('is-invalid');
                }
            }.bind(this)
        });
    });
</script>
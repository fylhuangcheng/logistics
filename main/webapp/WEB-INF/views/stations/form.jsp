<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header">
        <h5 class="mb-0">${empty station ? '新增网点' : '编辑网点'}</h5>
    </div>
    <div class="card-body">
        <!-- 错误提示 -->
        <c:if test="${not empty result and result.code != 200}">
            <div class="alert alert-danger">${result.message}</div>
        </c:if>

        <form id="stationForm" class="needs-validation" novalidate>
            <c:if test="${not empty station}">
                <input type="hidden" name="stationId" value="${station.stationId}">
            </c:if>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="stationCode" class="form-label required">网点编码</label>
                    <input type="text" class="form-control" id="stationCode" name="stationCode"
                           value="${station.stationCode}" required maxlength="50">
                    <div class="invalid-feedback">请输入网点编码</div>
                </div>

                <div class="col-md-6 mb-3">
                    <label for="stationName" class="form-label required">网点名称</label>
                    <input type="text" class="form-control" id="stationName" name="stationName"
                           value="${station.stationName}" required maxlength="100">
                    <div class="invalid-feedback">请输入网点名称</div>
                </div>
            </div>

            <div class="mb-3">
                <label for="address" class="form-label required">地址</label>
                <input type="text" class="form-control" id="address" name="address"
                       value="${station.address}" required maxlength="200">
                <div class="invalid-feedback">请输入地址</div>
            </div>

            <div class="mb-3">
                <label for="phone" class="form-label">联系电话</label>
                <input type="tel" class="form-control" id="phone" name="phone"
                       value="${station.phone}" maxlength="20">
            </div>

            <div class="mb-3">
                <label for="status" class="form-label">状态</label>
                <select class="form-select" id="status" name="status">
                    <option value="1" ${empty station or station.status == 1 ? 'selected' : ''}>启用</option>
                    <option value="0" ${station.status == 0 ? 'selected' : ''}>停用</option>
                </select>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <a href="${pageContext.request.contextPath}/stations" class="btn btn-secondary me-2">取消</a>
                <button type="button" class="btn btn-primary" onclick="submitForm()">
                    ${empty station ? '创建' : '更新'}
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    $(document).ready(function() {
        $('#stationCode').on('blur', function() {
            const code = $(this).val();
            if (code.trim() === '') return;

            // 如果是编辑模式且编码未改变，不检查
            const originalCode = '${station.stationCode}';
            if (originalCode && code === originalCode) return;

            $.ajax({
                url: '${pageContext.request.contextPath}/api/stations/check-code?code=' + encodeURIComponent(code),
                type: 'GET',
                success: function(response) {
                    if (response.code === 200 && response.data) {
                        $('#stationCode').addClass('is-invalid');
                        $('#stationCode').next('.invalid-feedback').text('网点编码已存在');
                    } else {
                        $('#stationCode').removeClass('is-invalid');
                    }
                }
            });
        });
    });

    function submitForm() {
        const form = document.getElementById('stationForm');
        if (!Utils.validateForm(form)) {
            return;
        }

        const formData = {
            stationCode: $('#stationCode').val().trim(),
            stationName: $('#stationName').val().trim(),
            address: $('#address').val().trim(),
            phone: $('#phone').val().trim(),
            status: $('#status').val()
        };

        if (formData.stationCode === '') {
            $('#stationCode').addClass('is-invalid');
            $('#stationCode').next('.invalid-feedback').text('请输入网点编码');
            return;
        }

        if (formData.stationName === '') {
            $('#stationName').addClass('is-invalid');
            return;
        }

        if (formData.address === '') {
            $('#address').addClass('is-invalid');
            return;
        }

        const stationId = $('input[name="stationId"]').val();
        if (stationId) {
            formData.stationId = parseInt(stationId);
        }

        const url = stationId
            ? '${pageContext.request.contextPath}/api/stations/' + stationId
            : '${pageContext.request.contextPath}/api/stations';
        const method = stationId ? 'PUT' : 'POST';

        Utils.showLoading();

        $.ajax({
            url: url,
            type: method,
            contentType: 'application/json',
            data: JSON.stringify(formData),
            dataType: 'json',
            success: function(response) {
                Utils.hideLoading();
                if (response.code === 200) {
                    Utils.showSuccess(response.message || '操作成功');
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/stations?success=' +
                            encodeURIComponent(response.message || '操作成功');
                    }, 1000);
                } else {
                    Utils.showError(response.message || '操作失败');
                }
            },
            error: function(xhr) {
                Utils.hideLoading();
                let errorMsg = '请求失败';
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    errorMsg = xhr.responseJSON.message;
                } else if (xhr.statusText) {
                    errorMsg = xhr.statusText;
                }
                Utils.showError(errorMsg);
            }
        });
    }
</script>
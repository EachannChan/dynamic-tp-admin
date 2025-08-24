/*
 * All Rights Reserved: Copyright [2024] [Zhuang Pan (paynezhuang@gmail.com)]
 * Open Source Agreement: Apache License, Version 2.0
 * For educational purposes only, commercial use shall comply with the author's copyright information.
 * The author does not guarantee or assume any responsibility for the risks of using software.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.dromara.dynamictp.admin.modules.monitor.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import org.apache.commons.lang3.ObjectUtils;
import org.dromara.dynamictp.admin.common.util.LongUtil;
import org.dromara.dynamictp.admin.infrastructure.enums.FileCategoryEnum;
import org.dromara.dynamictp.admin.infrastructure.page.PageQuery;
import org.dromara.dynamictp.admin.modules.monitor.domain.bo.MonFileBO;
import org.dromara.dynamictp.admin.modules.monitor.domain.entity.MonFile;
import org.dromara.dynamictp.admin.modules.monitor.repository.mapper.MonFileMapper;
import org.dromara.dynamictp.admin.modules.monitor.service.IMonFileService;
import org.dromara.dynamictp.admin.starter.common.util.FileUtil;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

/**
 * 文件管理 Service 服务接口实现层
 *
 * @Author monitor
 * @ProjectName panis-boot
 * @ClassName org.dromara.dynamictp.admin.modules.monitor.service.impl.MonFileServiceImpl
 * @CreateTime 2024-11-20 - 17:16:20
 */

@Service
@RequiredArgsConstructor
public class MonFileServiceImpl extends ServiceImpl<MonFileMapper, MonFile> implements IMonFileService {

    @Override
    public IPage<MonFile> listMonFilePage(PageQuery pageQuery, MonFileBO monFileBO) {
        LambdaQueryWrapper<MonFile> queryWrapper = new LambdaQueryWrapper<MonFile>()
                .like(ObjectUtils.isNotEmpty(monFileBO.getOrderNo()), MonFile::getOrderNo, monFileBO.getOrderNo())
                .eq(ObjectUtils.isNotEmpty(monFileBO.getCategory()), MonFile::getCategory, monFileBO.getCategory())
                .eq(ObjectUtils.isNotEmpty(monFileBO.getLocation()), MonFile::getLocation, monFileBO.getLocation())
                .like(ObjectUtils.isNotEmpty(monFileBO.getName()), MonFile::getName, monFileBO.getName())
                .orderByDesc(MonFile::getCreateTime);
        return baseMapper.selectPage(pageQuery.buildPage(), queryWrapper);
    }

    @Override
    @SneakyThrows
    public boolean putFile(MultipartFile file) {
        // 简化文件上传逻辑，直接保存文件信息到数据库
        MonFile monFile = of(file);
        return super.save(monFile);
    }

    @Override
    public String preview(Long id) {
        MonFile monFile = super.getById(id);
        // 简化预览逻辑，返回文件路径
        return monFile != null ? monFile.getPath() : "";
    }

    @Override
    public boolean removeBatchByIds(Collection<?> list) {
        // 移除OSS同步删除逻辑
        return super.removeBatchByIds(list, true);
    }

    @Override
    public void syncDeleteWithOSS(List<Long> ids) {
        // OSS功能已移除，此方法不再需要
        // 可以保留空实现以保持接口兼容性
    }

    /**
     * 转换文件信息
     *
     * @param file 文件
     * @return {@link MonFile } 文件信息
     * @author payne.zhuang
     * @CreateTime 2024-11-26 - 11:55:47
     */
    private MonFile of(MultipartFile file) {
        String originalFilename = file.getOriginalFilename();
        String uuid = UUID.randomUUID().toString();
        String path = "/uploads/" + uuid + "/" + originalFilename;
        
        return MonFile.builder()
                .length(file.getSize())
                .name(originalFilename)
                .path(path)
                .category(FileCategoryEnum.UPLOAD.getCode())
                .suffix(FileUtil.extension(originalFilename))
                .location("1") // 默认本地存储
                .contentType(file.getContentType())
                .uuid(uuid)
                .size(FileUtil.readableFileSize(file.getSize()))
                .build();
    }
}


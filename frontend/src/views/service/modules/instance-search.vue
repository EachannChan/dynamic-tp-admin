<script setup lang="ts">
import { ref } from 'vue';
import SvgIcon from '@/components/custom/svg-icon.vue';
import { getStatusFilterOptionsI18n } from './shared';
import { useI18n } from 'vue-i18n';

import { $t } from '@/locales';
interface Props {
  loading?: boolean;
}

interface Emits {
  (e: 'search', keyword: string): void;
  (e: 'filter', status: string): void;
  (e: 'refresh'): void;
}

const props = withDefaults(defineProps<Props>(), {
  loading: false
});

const emit = defineEmits<Emits>();

const { t } = useI18n();
const searchKeyword = ref('');
const statusFilter = ref('all');

// 状态过滤选项
const statusOptions = getStatusFilterOptionsI18n(t);

// 处理搜索
function handleSearch() {
  emit('search', searchKeyword.value);
}

// 处理状态过滤
function handleStatusFilter() {
  emit('filter', statusFilter.value);
}

// 处理刷新
function handleRefresh() {
  emit('refresh');
}

// 清空搜索
function handleClear() {
  searchKeyword.value = '';
  emit('search', '');
}
</script>

<template>
  <NCard :bordered="false"
         class="mb-6">
    <div class="flex items-center justify-between">
      <div class="flex items-center space-x-4">
        <NInput v-model="searchKeyword"
                :placeholder="$t('common.keywordSearch')"
                class="w-64"
                clearable
                @clear="handleClear"
                @keyup.enter="handleSearch">
          <template #prefix>
            <SvgIcon icon="mdi:magnify" />
          </template>
        </NInput>
        <NSelect v-model="statusFilter"
                 :options="statusOptions"
                 class="w-32"
                 @update:value="handleStatusFilter" />
        <NButton @click="handleSearch">
          {{ $t('common.search') }}
        </NButton>
      </div>
      <div class="flex items-center space-x-2">
        <NButton :loading="loading"
                 @click="handleRefresh">
          <template #icon>
            <SvgIcon icon="mdi:refresh" />
          </template>
          {{ $t('common.refresh') }}
        </NButton>
      </div>
    </div>
  </NCard>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useI18n } from 'vue-i18n';
import SvgIcon from '@/components/custom/svg-icon.vue';
import { $t } from '@/locales';

interface Props {
  loading?: boolean;
}

interface Emits {
  (e: 'search', keyword: string): void;
  (e: 'refresh'): void;
}

const props = withDefaults(defineProps<Props>(), {
  loading: false
});

const emit = defineEmits<Emits>();

const searchKeyword = ref('');

// 处理搜索
function handleSearch() {
  emit('search', searchKeyword.value);
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
                :placeholder="$t('page.servicePage.searchPlaceholder')"
                class="w-64"
                clearable
                @clear="handleClear"
                @keyup.enter="handleSearch">
          <template #prefix>
            <SvgIcon icon="mdi:magnify" />
          </template>
        </NInput>
        <NButton @click="handleSearch">
          {{ $t('page.servicePage.actions.search') }}
        </NButton>
      </div>
      <div class="flex items-center space-x-2">
        <NButton :loading="loading"
                 @click="handleRefresh">
          <template #icon>
            <SvgIcon icon="mdi:refresh" />
          </template>
          {{ $t('page.servicePage.actions.refresh') }}
        </NButton>
      </div>
    </div>
  </NCard>
</template>

<script setup lang="ts">
import { onMounted, ref, watch } from 'vue';
import { fetchGetClientList } from '@/service/api';

interface Props {
  modelValue?: string;
}

interface Emits {
  (e: 'update:modelValue', value: string): void;
  (e: 'change', client: any): void;
}

const props = defineProps<Props>();
const emit = defineEmits<Emits>();

// 客户端列表
const clients = ref<any[]>([]);
// 加载状态
const loading = ref(false);
// 选中的客户端
const selectedClient = ref<string>('');

// 获取客户端列表
async function getClientList() {
  try {
    loading.value = true;
    const { error, data } = await fetchGetClientList();
    if (!error && data) {
      clients.value = data;
      // 如果没有选中客户端且有客户端列表，默认选择第一个
      if (!selectedClient.value && data.length > 0) {
        selectedClient.value = data[0].clientId;
        emit('update:modelValue', data[0].clientId);
        emit('change', data[0]);
      }
    }
  } catch (err) {
    console.error('获取客户端列表失败:', err);
  } finally {
    loading.value = false;
  }
}

// 处理客户端切换
function handleClientChange(clientId: string) {
  selectedClient.value = clientId;
  emit('update:modelValue', clientId);

  const client = clients.value.find((c: any) => c.clientId === clientId);
  if (client) {
    emit('change', client);
  }
}

// 获取客户端状态颜色
function getStatusColor(status: string) {
  return status === 'online' ? 'success' : 'error';
}

// 获取客户端状态文本
function getStatusText(status: string) {
  return status === 'online' ? '在线' : '离线';
}

// 监听props变化
watch(
  () => props.modelValue,
  (newValue: string | undefined) => {
    if (newValue && newValue !== selectedClient.value) {
      selectedClient.value = newValue;
    }
  },
  { immediate: true }
);

onMounted(() => {
  getClientList();
});
</script>

<template>
  <NCard title="客户端选择" :bordered="false" class="mb-4">
    <template #header-extra>
      <NButton size="small" :loading="loading" @click="getClientList">
        <IconRefresh class="mr-1" />
        刷新
      </NButton>
    </template>

    <div v-if="!loading && clients.length === 0" class="flex items-center justify-center py-12">
      <NEmpty description="暂无客户端" />
    </div>

    <div v-else class="grid grid-cols-1 gap-4 lg:grid-cols-3 sm:grid-cols-2 xl:grid-cols-4">
      <div
        v-for="client in clients"
        :key="client.clientId"
        class="relative cursor-pointer transition-all duration-200 hover:shadow-md"
        :class="selectedClient === client.clientId ? 'ring-2 ring-primary ring-opacity-50' : ''"
        @click="handleClientChange(client.clientId)"
      >
        <NCard
          :bordered="true"
          size="small"
          class="h-full"
          :class="selectedClient === client.clientId ? 'border-primary bg-primary-50' : 'hover:border-gray-300'"
        >
          <div class="flex items-start space-x-3">
            <div class="flex-shrink-0">
              <div class="h-10 w-10 flex items-center justify-center rounded-full bg-primary-100">
                <IconMonitor class="text-lg text-primary" />
              </div>
            </div>
            <div class="min-w-0 flex-1">
              <div class="mb-2 flex items-center justify-between">
                <h3 class="truncate text-sm text-gray-900 font-medium">
                  {{ client.clientName }}
                </h3>
                <NTag :type="getStatusColor(client.status)" size="small">
                  {{ getStatusText(client.status) }}
                </NTag>
              </div>
              <div class="mb-2 text-xs text-gray-500">{{ client.clientIp }}:{{ client.clientPort }}</div>
            </div>
          </div>
        </NCard>
      </div>
    </div>
  </NCard>
</template>

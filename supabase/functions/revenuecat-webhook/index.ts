// deno-lint-ignore-file no-explicit-any
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

Deno.serve(async (req) => {
  try {
    // 1. Inicializa o Client do Supabase (Service Role para poder editar usuários)
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    const supabase = createClient(supabaseUrl, supabaseKey)

    // 2. Opcional: Validar Authorization Header enviado pelo RevenueCat
    // Se você configurou um "Authorization Header" no painel do RevenueCat, valide aqui.
    /*
    const authHeader = req.headers.get('Authorization')
    if (authHeader !== 'Bearer SEU_TOKEN_CONFIGURADO_NO_REVENUECAT') {
      return new Response('Unauthorized', { status: 401 })
    }
    */

    const body = await req.json()
    console.log('RevenueCat Webhook received:', body)

    const { event } = body
    if (!event) {
       return new Response('No event found', { status: 400 })
    }

    const appUserId = event.app_user_id
    const eventType = event.type

    if (!appUserId) {
       return new Response('Missing app_user_id', { status: 400 })
    }

    // 3. Define a lógica de Status Premium
    // Tipos de evento que GARANTEM acesso Premium:
    const premiumEvents = [
       'INITIAL_PURCHASE',
       'RENEWAL',
       'UNCANCEL', // Usuário cancelou o cancelamento
       'SUBSCRIPTION_EXTENDED',
       'NON_RENEWING_PURCHASE'
    ]

    // Tipos de evento que REMOVEM acesso Premium:
    const expirationEvents = [
       'EXPIRATION',
       'CANCELLATION', // Dependendo da regra, pode ser imediato ou só na expiração
       'BILLING_ISSUE',
       'PRODUCT_CHANGE', // Se o novo produto não for premium (raro)
       'REFUND'
    ]

    let isPremium = null

    if (premiumEvents.includes(eventType)) {
       isPremium = true
    } else if (expirationEvents.includes(eventType)) {
       // Importante: No caso de CANCELLATION, o RevenueCat avisa que o usuário cancelou 
       // mas ele ainda pode ter tempo restante de assinatura. 
       // Se o evento for EXPIRATION, o acesso deve ser removido imediatamente.
       if (eventType === 'EXPIRATION' || eventType === 'REFUND' || eventType === 'BILLING_ISSUE') {
          isPremium = false
       }
    }

    // 4. Atualiza o perfil do usuário no Supabase
    if (isPremium !== null) {
       console.log(`Updating user ${appUserId}: is_premium = ${isPremium}`)
       
       const { error } = await supabase
         .from('profiles') // Ajuste para o nome da sua tabela de perfis (profiles ou users)
         .update({ 
           is_premium: isPremium,
           updated_at: new Date().toISOString()
         })
         .eq('id', appUserId)

       if (error) {
         console.error('Database update error:', error)
         return new Response(JSON.stringify({ error: error.message }), { status: 500 })
       }
    }

    return new Response(JSON.stringify({ message: 'Webhook processed successfully' }), {
      headers: { 'Content-Type': 'application/json' },
    })

  } catch (err) {
    console.error('Webhook processing failed:', err)
    return new Response(err.message, { status: 500 })
  }
})

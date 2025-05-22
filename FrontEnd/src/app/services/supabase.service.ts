// src/app/services/supabase.service.ts
import { Injectable } from '@angular/core';
import { createClient, SupabaseClient } from '@supabase/supabase-js';

@Injectable({
  providedIn: 'root'
})
export class SupabaseService {
  private supabase: SupabaseClient;

  constructor() {
    const supabaseUrl = 'https://cblssbvfgxtadeevsldy.supabase.co/'; 
    const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNibHNzYnZmZ3h0YWRlZXZzbGR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3NDE3MzMsImV4cCI6MjA2MzMxNzczM30.6vfHowlW_UT2jeO1MdaqlB6lWWd3qloqppOAsUCD3Ts';

    this.supabase = createClient(supabaseUrl, supabaseKey);
  }

  get client() {
    return this.supabase;
  }

  /**
   * Retourne l'URL publique d'un fichier (si le bucket est public)
   */
  getPublicMediaUrl(path: string): string {
    const { data } = this.supabase.storage.from('nocomment').getPublicUrl(path);
    return data?.publicUrl || '';
  }

  /**
   * Retourne une URL signée (temporaire) pour un fichier (si le bucket est privé)
   */
  async getSignedMediaUrl(path: string, expiresInSeconds = 3600): Promise<string> {
    const { data, error } = await this.supabase.storage.from('nocomment').createSignedUrl(path, expiresInSeconds);
    if (error) {
      console.error("Erreur lors de la génération de l'URL signée :", error.message);
      return '';
    }
    return data?.signedUrl || '';
  }
}

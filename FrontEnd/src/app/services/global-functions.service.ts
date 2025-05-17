// src/app/services/global-functions.service.ts

import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class GlobalFunctionsService {

  constructor() {}

  getCurrentDateTimeSQL(): string {
    const now = new Date();

    // Format SQL: YYYY-MM-DD HH:MM:SS
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0'); // Mois (1-12)
    const day = String(now.getDate()).padStart(2, '0'); // Jour (1-31)
    const hours = String(now.getHours()).padStart(2, '0'); // Heures (0-23)
    const minutes = String(now.getMinutes()).padStart(2, '0'); // Minutes (0-59)
    const seconds = String(now.getSeconds()).padStart(2, '0'); // Secondes (0-59)

    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  }

  formatRelativeDateFR(dateString: string): string {
    const now = new Date();
    const date = new Date(dateString);
    const diffMs = now.getTime() - date.getTime();

    const diffMinutes = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMinutes / 60);

    if (diffMinutes < 60) {
      return `Il y a ${diffMinutes} minute${diffMinutes > 1 ? 's' : ''}`;
    }

    if (diffHours < 48) {
      return `Il y a ${diffHours}h`;
    }

    return new Intl.DateTimeFormat('fr-FR', {
      dateStyle: 'short',
      timeStyle: 'medium',
      timeZone: 'Europe/Paris'
    }).format(date);
  }

}
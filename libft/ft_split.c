/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_split.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: magahat <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/21 09:08:00 by magahat           #+#    #+#             */
/*   Updated: 2024/05/27 13:32:25 by magahat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

static int	ft_free(char **ar, int j)
{
	int	i;

	i = 0;
	if (!ar[j])
	{
		while (i < j)
		{
			free(ar[i]);
			i++;
		}
		free(ar);
		return (1);
	}
	return (0);
}

static int	ft_count_w(const char *str, char c)
{
	int	i;
	int	count;

	i = 0;
	count = 0;
	while (str[i])
	{
		if (str[i] != c)
		{
			while (str[i] != c && str[i])
				i++;
			count++;
		}
		while (str[i] == c && str[i])
			i++;
	}
	return (count);
}

static char	*ft_str_cpy(const char *str, int k)
{
	int		i;
	char	*dest;

	dest = malloc(sizeof(char) * (k + 1));
	if (!dest)
		return (NULL);
	i = 0;
	while (i < k && str[i])
	{
		dest[i] = str[i];
		i++;
	}
	dest[i] = '\0';
	return (dest);
}

char	**ft_split(const char *s, char c)
{
	char	**ar;
	int		i;
	int		j;
	int		k;

	ar = malloc(sizeof(char *) * (ft_count_w(s, c) + 1));
	if (!ar)
		return (NULL);
	i = 0;
	j = 0;
	while (s[i] && j < ft_count_w(s, c))
	{
		while (s[i] == c && s[i])
			i++;
		k = i;
		while (s[i] != c && s[i])
			i++;
		ar[j] = ft_str_cpy((char *)&s[k], (i - k));
		if (ft_free(ar, j) == 1)
			return (NULL);
		j++;
	}
	ar[j] = NULL;
	return (ar);
}
